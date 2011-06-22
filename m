From: Phil Turmel <philip@turmel.org>
Subject: Re: reaid problem at reboot
Date: Tue, 21 Jun 2011 22:30:25 -0400
Message-ID: <4E0153C1.1040708@turmel.org>
References: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>,<4E00FC8A.1050908@turmel.org> <BAY158-w388BBEAFF686EAA222B346C0510@phx.gbl>,<4E0113FE.503@turmel.org> <BAY158-w3076B56F0F37E7F3DA4866C0500@phx.gbl>,<4E0146B6.40101@turmel.org> <BAY158-w9526A91B9B67956C12924C0500@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY158-w9526A91B9B67956C12924C0500@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: william L'Heureux <wil_c_will@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi William,

Progress!

On 06/21/2011 09:50 PM, william L'Heureux wrote:
> for x in /dev/sd[abcdefghijkm]1 ; do echo "**** $x ****" ; dd if=$x skip=2056 count=2 2>/dev/null |strings ; done
> **** /dev/sda1 ****
> **** /dev/sdb1 ****

[...]

> **** /dev/sdc1 ****
> **** /dev/sdd1 ****
> !HV]3$xK
> M1N+>
> vgRQID6  {
> *= "RUodpI-jXin-D<
> s-fC3R-$hjA=hQ4l-41dAaJ"
> seqnoV
> ctates =0["RESIZEABLE", "RE7
> ", 2WRIDE"]
> jags = []
> extent_
> ze - 81)2
> mqx_lv = 0
> max_pv = F
> phisicql_v
> 6wmes {
> pv0 {
> &"V5s1yI=XD3T-FXlB-VDYd-tUfo-eI#
> -hXAfVW2
> defice = "/dev/md1"
> atuc = K"AL\
> @ATABLE"]
> flags =
> duv_syze -V2814057984
> pe_sta
>  = %12
> `e_c
> zjt = 953864
> pv6[{
> it = 2BzZs
> n-uC9b-MQne-caBo-
> Np3-)xkA=NnGeUA"
> device = "/dev
> stqtus0E"["ALLOCATABLE"]
> ags0= [M
> pize = 7814057984Z
> e_sdart0= 5!q
> pe_count = 95386
> **** /dev/sde1 ****
> **** /dev/sdf1 ****
> **** /dev/sdg1 ****

[...]

> **** /dev/sdh1 ****
> **** /dev/sdi1 ****
> "RiodpI-jXin-
> dAaJ"
> seqn
> a82j
> SIfEABLE", "R
> extent
> max_pv =
> pv0 {
> B-jDYd-tUfo-e
> /dev/md1"
> ABpE"]
> flags
> 40      7984
> pe_st
> 53864
> C9^-MQne-caBo
> deJice = "/de
> q82B
> ALpOCATABLE"]
>  781405798
> 7m!_
> _cSunt = 9538
> **** /dev/sdj1 ****
>  LVM2 x[5A%r0N*>
> vgRAID60 {
> id = "RUodpI-jXin-DEjs-fS3R-4hjA-hQ4l-41dAaJ"
> seqno = 2
> status = ["RESIZEABLE", "READ", "WRITE"]
> flags = []
> extent_size = 8192
> max_lv = 0
> max_pv = 0
> physical_volumes {
> pv0 {
> id = "V5c1yI-XD3D-FXlB-VDYd-tUfo-eIUC-hXQfVW"
> device = "/dev/md1"
> status = ["ALLOCATABLE"]
> flags = []
> dev_size = 7814057984
> pe_start = 512
> pe_count = 953864
> pv1 {
> id = "BzZcan-uC9b-MQne-caBo-tYp3-9xkA-NnGuBE"
> device = "/dev/md2"
> status = ["ALLOCATABLE"]
> flags = []
> dev_size = 7814057984
> pe_start = 512
> pe_count = 953864
> **** /dev/sdk1 ****

[...]

> **** /dev/sdm1 ****
> 
> 
> for x in /dev/sd[abcdefghijkm]1 ; do echo "**** $x ****" ; dd if=$x skip=2048 count=1 2>/dev/null |hexdump -C ; done
> **** /dev/sda1 ****

[...]  (These weren't helpful, after all.)

> btw, /dev/md1 is fine 100%

Good.  That simplifies the rest.

> the drives for /dev/md0 --> 'a', 'c', 'd', 'h', 'i', 'j' 

Based on the above, 'j' is almost certainly the first disk in md0, and I suspect 'i' is the 'P' parity drive, and 'd' is the 'Q' parity drive.

Stop LVM, and stop md0, then re-create (re-assembly won't fix this):

mdadm --create --assume-clean /dev/md0 --raid-devices=6 --level=6 --chunk=128 /dev/sd{j,a,c,h,i,d}1

(You must not use the [] syntax here..., and "--assume-clean" is vital.)

restart LVM, then "fsck -n" to test.

If not yet good, shuffle 'a', 'c', & 'h'.

If still not good, swap 'i' & 'd', then try the combinations of 'a', 'c', and 'h' again.

Please let us know what combination, if any, works.  Absolutely do *not* attempt to mount until "fsck -n" reports no problems, or not many problems.

Phil
