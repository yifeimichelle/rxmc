      Subroutine Move(Av1,Av2,Delta)
      Implicit None

      Include 'commons.inc'

C     Displace A Randomly Selected Particle

      Logical Laccept
      Integer Ib,Ipart
      Double Precision Rxtrial,Rytrial,Rztrial,Xi,Yi,Zi,Randomnumber,Unew,Uold
     $     ,Virnew,Virold,Av1,Av2,Delta

      If(Npart.Eq.0) Return

      Ipart = 1 + Int(Dble(Npart)*Randomnumber())
      Ib    = Ibox(Ipart)

      Rxtrial = Rx(Ipart) + (2.0d0*Randomnumber()-1.0d0)*Delta
      Rytrial = Ry(Ipart) + (2.0d0*Randomnumber()-1.0d0)*Delta
      Rztrial = Rz(Ipart) + (2.0d0*Randomnumber()-1.0d0)*Delta

C     Put Back In The Box

      If(Rxtrial.Lt.0.0d0) Then
         Rxtrial = Rxtrial + Box(Ib)
      Elseif(Rxtrial.Gt.Box(Ib)) Then
         Rxtrial = Rxtrial - Box(Ib)
      Endif

      If(Rytrial.Lt.0.0d0) Then
         Rytrial = Rytrial + Box(Ib)
      Elseif(Rytrial.Gt.Box(Ib)) Then
         Rytrial = Rytrial - Box(Ib)
      Endif

      If(Rztrial.Lt.0.0d0) Then
         Rztrial = Rztrial + Box(Ib)
      Elseif(Rztrial.Gt.Box(Ib)) Then
         Rztrial = Rztrial - Box(Ib)
      Endif

      Xi = Rx(Ipart)
      Yi = Ry(Ipart)
      Zi = Rz(Ipart)

      Call Epart(Ib,Virold,Uold,Xi,Yi,Zi,Ipart,Types(Ipart))
      Call Epart(Ib,Virnew,Unew,Rxtrial,Rytrial,Rztrial
     &     ,Ipart,Types(Ipart))

      Call Accept(Dexp(-Beta*(Unew-Uold)),Laccept)

      Av2 = Av2 + 1.0d0

C     Accept Or Reject

      If(Laccept) Then
         Av1 = Av1 + 1.0d0

         Etotal(Ib) = Etotal(Ib) + Unew   - Uold
         Vtotal(Ib) = Vtotal(Ib) + Virnew - Virold

         Rx(Ipart) = Rxtrial
         Ry(Ipart) = Rytrial
         Rz(Ipart) = Rztrial
      Endif

      Return
      End
