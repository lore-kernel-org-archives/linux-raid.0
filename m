From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: RAID10 performance with 20 drives
Date: Thu, 1 Jun 2017 09:33:18 +0300
Message-ID: <20170601063318.GJ24459@reaktio.net>
References: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
 <20170531191441.40240b7f@natsu>
 <CAGqmV7qB=8a_peu2gsU9Xne6v4nymT-O+vhDwkwaUJhyYpkieg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGqmV7qB=8a_peu2gsU9Xne6v4nymT-O+vhDwkwaUJhyYpkieg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jun 01, 2017 at 12:59:01PM +0700, CoolCold wrote:
> Hello!
> Roman, i've updated the kernel to 4.11 and started "check" action,
> results are basically the same, output on github
> https://gist.github.com/CoolCold/663de7c006490d7fd0ac7cc98b7a6844
> 1 cpu is overloaded, not more than 1.3 - 1.4GB/sec
> 

You need to provide more details about the actual storage setup.

Like already said/asked for:

- Which HBA are you using?
- Which PCIe link speed are you using for the HBA?
- Which driver version for the HBA?
- Which HBA firmware version?

- How are the disks connected to the HBA ? Direct-connect, or via an Expander? 
- If you have an expander, what's the (SAS) link speed/count between the HBA(s) and the Expander? 


-- Pasi

> On Wed, May 31, 2017 at 9:14 PM, Roman Mamedov <rm@romanrm.net> wrote:
> > On Wed, 31 May 2017 19:20:10 +0700
> > CoolCold <coolthecold@gmail.com> wrote:
> >
> >> Creation (disable write intent bitmap, with bitmap all is much worse):
> >> mdadm --create -c 64 -b none -n 20 -l 10 /dev/md1 /dev/sde /dev/sdf
> >> /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm
> >> /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt
> >> /dev/sdu /dev/sdv /dev/sdw /dev/sdx
> >>
> >> kernel:
> >> [root@spare-a17484327407661 rovchinnikov]# cat /proc/version
> >> Linux version 3.10.0-327.el7.x86_64 (builder@kbuilder.dev.centos.org)
> >> (gcc version 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC) ) #1 SMP Thu Nov
> >> 19 22:10:57 UTC 2015
> >>
> >> So, the question is - why cpu usage is so high and I suppose is a limit here?
> >
> > Definitely try a newer kernel, 4.4 at the very least; if no changes then 4.11.
> >
> > Also I would suggest to try out larger chunk sizes, such as 512 and 1024 KB.
> >
> > If you plan to use this long-term in production, also read up on the various
> > RAID10 data layouts and their benefits and downsides (man md, search for
> > "layout"; and search the Internet for benchmarks of all three).
> >
> > --
> > With respect,
> > Roman
> 
> 
> 
> -- 
> Best regards,
> [COOLCOLD-RIPN]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
