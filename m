From: Erwan MAS <erwan@mas.nom.fr>
Subject: Re: Raid10 & Rhel
Date: Thu, 19 Nov 2009 09:45:54 +0100
Message-ID: <20091119084554.GN1863@voyageur.mas.nom.fr>
References: <20091118235110.GM1863@voyageur.mas.nom.fr> <20091119123250.5f0474e1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091119123250.5f0474e1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 19, 2009 at 12:32:50PM +1100, Neil Brown wrote:
> On Thu, 19 Nov 2009 00:51:10 +0100
> Erwan MAS <erwan@mas.nom.fr> wrote:
> 
> > Hello ,
> > 
> > I have found this bug in RehHat Bugzilla 
> > 
> > "md raid10 far layout resync corruption bug in rhel kernel
> > 2.6.18-92.1.13.el5"
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=468379
> > 
> > 
> > The bug is not very verbose .
> > 
> > Someone have more information ?
> > 
> > 
> 
> If you look in the kernel git history for that patch that is identified,
> you find it comes with a comment as below.
> Maybe that is the more information you want?  You aren't very specific.

Yes . Thank you .

I think , I had this bug , when i see this in my /var/log/messages .

Nov 18 15:46:30 tutur kernel: attempt to access beyond end of device
Nov 18 15:46:30 tutur kernel: sda3: rw=1, want=142541374619776, limit=527349690
Nov 18 15:46:30 tutur kernel: raid10: Disk failure on sda3, disabling device. 
Nov 18 15:46:30 tutur kernel:   Operation continuing on 2 devices
Nov 18 15:46:30 tutur kernel: md: md2: sync done.
Nov 18 15:46:30 tutur kernel: RAID10 conf printout:
Nov 18 15:46:30 tutur kernel:  --- wd:2 rd:4
Nov 18 15:46:30 tutur kernel:  disk 0, wo:0, o:1, dev:sdc3
Nov 18 15:46:30 tutur kernel:  disk 1, wo:1, o:0, dev:sda3
Nov 18 15:46:30 tutur kernel:  disk 2, wo:0, o:1, dev:sdd3
Nov 18 15:46:30 tutur kernel: RAID10 conf printout:
Nov 18 15:46:30 tutur kernel:  --- wd:2 rd:4
Nov 18 15:46:30 tutur kernel:  disk 0, wo:0, o:1, dev:sdc3
Nov 18 15:46:30 tutur kernel:  disk 2, wo:0, o:1, dev:sdd3
Nov 18 16:13:53 tutur kernel: md: unbind<sda3>
Nov 18 16:13:53 tutur kernel: md: export_rdev(sda3)

All block of data are corrupted or only a part of the device ?

This bug occur in every raid10f2 or it's occur when physicals devices
have not the right size ( aka after all operations there are no rounding needs ) 
or when the number of physicals devices > 2 ?

Generally i build my raid device in degraded mode , i move data with pvmove ,
and after i push the remaining disk and i do a resync .

-- 
     ____________________________________________________________
    / Erwan MAS                                                 /\
   | mailto:erwan@mas.nom.fr                                   |_/
___|________________________________________________________   |
\___________________________________________________________\__/
