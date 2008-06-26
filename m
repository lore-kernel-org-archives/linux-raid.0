From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Slowww raid check (raid10, f2)
Date: Thu, 26 Jun 2008 15:13:17 -0500
Message-ID: <4863F85D.7080502@gmail.com>
References: <cccedfc60806260621ud3af517j959f5ce3c2e521ef@mail.gmail.com>	 <4863A6A1.3010408@gmail.com> <cccedfc60806261303t4a6d4124w2ab12227d8acb99f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60806261303t4a6d4124w2ab12227d8acb99f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:

> MCP55, built-in.
> cat /proc/interrupts:
> 
>            CPU0       CPU1
>   0:      67908  136036611   IO-APIC-edge      timer
>   1:          0         10   IO-APIC-edge      i8042
>   2:          0          0    XT-PIC-XT        cascade
>   5:    8325169   15373702   IO-APIC-fasteoi   sata_nv, ehci_hcd:usb1
>   7:          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
>   8:          0          0   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-edge      acpi
>  10:    3722699    7890387   IO-APIC-fasteoi   sata_nv
>  11:          0          0   IO-APIC-fasteoi   sata_nv
>  14:    1339948    1448257   IO-APIC-edge      libata
>  15:          0          0   IO-APIC-edge      libata
> 4345:   62529065       1494   PCI-MSI-edge      eth1
> 4346:          8   60190576   PCI-MSI-edge      eth0
> NMI:          0          0
> LOC:  136110735  136110816
> ERR:          0
> 
>> Do a test of "dd if=/dev/sdb4 of=/dev/null bs=64k" on 1 then 2 and the 3
>> disks while watching "vmstat 1" and see how it scales.
> 
> Start with 1, then 2, then 3. Then back to 2, then back to 1. Then done.
> 
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  1  1    392   9760 704136  17656    0    0 67968    16 1985 2578  0 24 48 29
>  1  1    392   9384 704632  17636    0    0 74900     0 1704 2540  0 26 45 29
>  2  1    392   9992 703148  18036    0    0 74516     0 1750 2581  0 25 46 29
>  2  0    392   9156 704096  18100    0    0 153856     0 4193 8686  0 55 25 20
>  2  1    392   9240 704328  17892    0    0 147606    32 3990 8608  0 58 20 23
>  3  0    392   9136 704444  17704    0    0 143434    52 3596 8087  0 52 17 30
>  1  2    392   9492 703880  18068    0    0 136604    12 3438 7205  0 50 23 26
>  1  2    392   9552 704272  17588    0    0 153984     0 3837 8461  0 57 21 21
>  1  1    392   9812 704160  17368    0    0 149399     0 3760 8121  0 54 20 26
>  2  1    392   9296 704464  17376    0    0 133546    32 3377 7822  0 52 18 30
>  3  1    392   9240 704040  17796    0    0 152696    16 3811 7704  0 57 16 28
>  3  3    392  10020 703296  17428    0    0 196994    36 5028 6354  0 75  1 23
>  3  0    392   9152 704172  17332    0    0 197809    28 5030 5603  0 74  0 25
>  2  2    392   9232 704440  17324    0    0 203131     0 5141 6030  0 75  0 24
>  3  2    392   9680 704112  16988    0    0 201973     0 5105 5601  1 78  0 22
>  2  1    400  10216 703656  17032    0    8 189088    52 4634 5853  0 69  0 31
>  3  1    400   9112 704664  17004    0    0 188936    44 4721 5495  0 70  2 28
>  1  4    400  10080 704132  17008    0    0 200736     4 5000 6037  0 78  1 21
>  3  2    400   9212 705012  16800    0    0 146072    40 3724 6490  0 54 16 30
>  1  1    400   9724 705988  17328    0    0 108857    32 2707 6034  0 39  9 51
>  1  1    400   9164 706800  17436    0    0 144175     0 3580 8223  0 52 21 26
>  1  2    400  10044 707708  17500    0    0 73452     0 1662 2560  0 26 46 27
> 
> 

That is a good built-in controller then, the scaling is almost perfect, 
predicted would be  74, 158, 222 vs. 74, 154, 205.

                             Roger
