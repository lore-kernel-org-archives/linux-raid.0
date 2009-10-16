From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Disappointing RAID10 Performance
Date: Fri, 16 Oct 2009 14:05:56 -0700 (PDT)
Message-ID: <715541.19877.qm@web38803.mail.mud.yahoo.com>
References: <B87EBE62-DE20-4BFC-9FBB-FFC8AD471331@riverbed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B87EBE62-DE20-4BFC-9FBB-FFC8AD471331@riverbed.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Fri, 10/16/09, Rob Becker <Rob.Becker@riverbed.com> wrote:
>    What command did you use to create your
> raid-10?

/
mdadm --create /dev/md0 --level=raid1 --chunk=256 --raid-disks=2 missing /dev/sdb1
swap
mdadm --create /dev/md1 --level=raid10 --layout=o2 --chunk=256 --raid-disks=2 missing /dev/sdb2
/home
mdadm --create /dev/md2 --level=raid10 --layout=o2 --chunk=1024 --raid-disks=2 missing /dev/sdb3
... then copied files and later added the sda parts to the array. (RAID conversion on live system)


>  You might try  
> running iostat in parallel to see if the read_balancer is
> properly  
> balancing the reads between the two disks.

Don't understand this as I'm a bit of a n00b...


--- On Fri, 10/16/09, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> If you only use your RAID-10 array for a single "dd
> if=bigfile of=/dev/null" then yes, it does not give you much
> over mirroring.
> 
> If you start using your drives for two "dd if=bigfile[12]
> of=/dev/null" at the same time, you will notice the
> difference.

OK so it was a fallacy to think this would help with large files, unless more than one is involved.




      
