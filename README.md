# SimpleCPU  
Designing, simulating, and implementing a Simple RISC Computer  

---

## Phase 2 Notes  

### **ST Control Sequence**  

| Step | Control Signals |
|------|---------------|
| **T0** | `PCout`, `MARin`, `IncPC`, `Zin` |
| **T1** | `Zlowout`, `PCin`, `Read`, `Mdatain[31..0]`, `MDRin` |
| **T2** | `MDRout`, `IRin` |
| **T3** | `GRB`, `BAout`, `Yin` |
| **T4** | `Cout`, `ADD`, `Zin` |
| **T5** | `Zlowout`, `MARin` |
| **T6** | `GRA`, `Rout`, `MDRin` |
| **T7** | `MDRout` |

### **JAL Control Sequence**  

| Step | Control Signals |
|------|---------------|
| **T0-T2** | Same as before for “Instruction Fetch" |
| **T3** | `PCout`, `R8in`  |
| **T2** | `Gra`, `Rout`, `PCin` |
