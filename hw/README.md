# Hardware — PolarFire® SoC FPGA MJPEG Video Streaming Design

This folder contains the Tcl scripts and source files needed to regenerate the Libero® SoC project for the MJPEG Video Streaming Design on the PolarFire® SoC Video Kit (MPFS250-VIDEO-KIT).

The design captures live video from a MIPI CSI2 camera sensor (IMX334), processes it through a hardware-accelerated video pipeline with Bayer-to-RGB conversion, color correction, and image enhancement, compresses it using a JPEG encoder in the FPGA fabric, and streams it over Gigabit Ethernet using RTP protocol.

## Validation Environment

| Item | Reference |
| --- | --- |
| Libero® SoC Design Suite | See the release notes on the [GitHub Releases](https://github.com/microchip-fpga-solutions/mpfs250-video-kit-mjpeg/releases) page |
| IP core versions | As specified in [`common/common.tcl`](common/common.tcl) |

## Directory Structure

```
hw/
├── script.tcl                          Top-level Libero build script
├── common/
│   └── common.tcl                      IP-core versions, tool profiles, device info
├── src/
│   ├── 1_create_design.tcl             Instantiates and wires IP cores, imports HDL
│   ├── 2_constrain_design.tcl          Imports I/O, timing, and floorplan constraints
│   ├── 3_implement_design.tcl          Runs synthesis, place-and-route, verifies timing
│   ├── 4_program_design.tcl            Generates the FlashPro Express programming job file
│   ├── cfg/
│   │   └── ENVM.cfg                    eNVM configuration for HSS boot
│   ├── components/                     Per-IP configuration Tcls and MSS configuration
│   ├── constraints/
│   │   ├── user.pdc                    Physical design constraints
│   │   ├── user.sdc                    Timing constraints
│   │   ├── VKPFSOC_MAC.pdc             MAC pin constraints
│   │   ├── VKPFSOC_MMUART0.pdc         MMUART0 pin constraints
│   │   └── VKPFSOC_MMUART1.pdc         MMUART1 pin constraints
│   └── hdl/
│       ├── apb_wrapper.vhd
│       ├── data_packer_mjpeg.vhd
│       ├── ddr_write_controller_jpeg_fifo.v
│       ├── frame_controls_gen.v
│       ├── ram2port.vhd
│       └── video_fifo.vhd
|
```

## Running the Tcl Flow

To regenerate the Libero project from these scripts:

1. Launch Libero® SoC.
2. Click **Project** > **Execute Script…**.
3. Click **Browse** and select `script.tcl` from this `hw/` folder.
4. Click **Run**.

After successful execution, the Libero project is created inside this folder.

## Tcl File Descriptions

| File | Purpose |
| --- | --- |
| `script.tcl` | Top-level script. Creates the Libero project directory, sets the target device (MPFS250T_ES-1FCG1152E), project name, and tool profiles, then invokes the scripts below in order to complete the full Libero design flow. |
| `common/common.tcl` | Central table of IP-core versions, tool profiles, and device information used by every downstream script. Update this file when moving to a new Libero or IP release. |
| `src/1_create_design.tcl` | Executes every core-configuration Tcl under `src/components/`, imports the HDL files from `src/hdl/`, and wires up the top-level SmartDesign. Components are sourced bottom-up: the configured IP cores first, then each SmartDesign level, ending with the `top` root. |
| `src/2_constrain_design.tcl` | Imports the constraints files from `src/constraints/` into the Libero project, derives the component constraints, and associates both sets with Synthesis, Place and Route, and Timing Verification. |
| `src/3_implement_design.tcl` | Runs synthesis, place-and-route, and timing verification. |
| `src/4_program_design.tcl` | Loads the HSS firmware image into the eNVM, generates the design-initialization data, and exports the FlashPro Express programming job file. |

## Updating for a New Libero or IP Release

To port this design to a newer Libero SoC or IP release:

1. Update the IP core version numbers in [`common/common.tcl`](common/common.tcl). 
2. Re-run the Tcl flow in the target Libero version.

If the flow fails after the update, check the following:

- **Libero-related errors** — review the Libero release notes for changes to design components, tools, or Tcl commands.
- **IP-core-related errors** — review the IP handbook and release notes for changes to configuration parameters, ports, or their functionality. Update the corresponding component Tcl under `src/components/` if the IP's configuration interface has changed.

For Tcl command syntax, see the *Libero SoC Tcl Command Reference Guide*.

## Support
-----------------------------------------------------------------------------------------------------------------------------------------
For questions about the Tcl flow or the design source, contact [Microchip Technical Support](https://www.microchip.com/support).
