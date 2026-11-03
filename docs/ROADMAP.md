1. Conexión: [x] Connect-tptAD; [ ] config manual ~/.tpt/tptAD.yaml.
2. Inventario: [x] las 5 Get-; [ ] Get-tptADOrganizationalUnit, [ ] Get-tptADComputerGroup.
3. Administración: [ ] New-tptADUser, [ ] Remove-tptADUser, [ ] Set-tptADUser (reset password, unlock), [ ] New-tptADGroup, [ ] Add-tptADGroupMember, [ ] Remove-tptADGroupMember.
4. Mantenimiento: [ ] Invoke-tptADPasswordReset (masivo), [ ] Invoke-tptADUnlock (cuentas bloqueadas).
5. Observabilidad: [ ] Get-tptADPasswordExpiry (usuarios con password por caducar), [ ] Test-tptADHealth.
6. Calidad: [ ] Testes Pester (requieren DC o stubs), [ ] CI.