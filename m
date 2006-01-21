From: Andy Gajetzki <andy.gajetzki@gmail.com>
Subject: Re: linear raid space utilization
Date: Sat, 21 Jan 2006 08:31:46 -0700
Message-ID: <cc5782160601210731n20c020dqb6a173135fcfc934@mail.gmail.com>
References: <cc5782160601202312y25bc339cvcb1973c24208da3@mail.gmail.com>
	 <43D1F548.6020407@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D1F548.6020407@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Thanks for the help. I used ddrescue to grab /dev/hdb and am now using
e2retrieve. I am somewhat optimistic that there will be at least
partial recovery ;). Have a great remainder of the weekend,
Andy Gajetzki

On 1/21/06, David Greaves <david@dgreaves.com> wrote:
> Andy Gajetzki wrote:
>
> >Hi there,  I recently had a disk go bad in a linear RAID built with
> >mdadm. The particular disk that failed was the last  device of the
> >RAID. I am curious about how  devices are utilized in a linear RAID.
> >Would the md be filled sequentially from device 1 upto 5? In other
> >words, what are the odds that the last disk was "empty" when it went
> >south?
> >
> >Thanks for your time,
> >
> >
> Linear raid does provide sequential blocks on disks 1...n
>
> So as long as the filesystem you used was something like 'dd
> of=/dev/md0' then you'd be OK <grin>
>
> However if you made a 'proper' filesystem on it then the disk usage
> would vary depending on whether it was ext2,ext3,xfs,jfs etc etc
>
> If the bad disk is totally gone then you're at the mercy of fs deign and
> fsck - otherwise try and use ddrescue to get an image of it (and the
> other disks). Make a 'safe' image and a 'working' image of the bad disk
> before attempting repair on 'working' images.
> (Of course you need lots of disk space so you may need new disks -
> depends how valuable your data is)
>
> HTH
>
> David
>
> --
>
>


--
Andrew Gajetzki  |  (403) 330-6552 | Fax: (780) 675-9402 | www.gajetzki.com
---------------------------------------------------------|------------------
XML Architect - Internet Scientific Publications LLC.    | www.ispub.com
Editor in Chief - Lethbridge Undergrad. Research Journal | www.lurj.org
Lead Developer - phirOSS Open Source Software            | www.phiross.org
Network Analyst - GSchools Inc.                          | www.gschools.com
---------------------------------------------------------|------------------
