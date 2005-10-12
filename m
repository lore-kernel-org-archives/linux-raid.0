From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Automatic drive partitioning
Date: Wed, 12 Oct 2005 11:21:18 +0200
Message-ID: <200510121121.18242.thomas.jarosch@intra2net.com>
References: <200510081910.15934.thomas.jarosch@intra2net.com> <Pine.LNX.4.44.0510081503490.28615-100000@coffee.psychology.mcmaster.ca> <17224.11487.659497.812038@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17224.11487.659497.812038@fisica.ufpr.br>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos,

On Saturday 08 October 2005 22:32, you wrote:
> Agreed. I've been using sfdisk without problems with various drives. I even
> usually start the first partition on sector 1... When I want to copy
> the partition table of one disk to the other I do
> sfdisk -d partitioned-disk | sfdisk --force new-disk.
>
> It works for drives of different sizes as well. Yesterday I tried
> this pipe with logical partitions and even with force it refused,
> complaining that an extended partition didn't start at a cylinder
> boundary. That's non-sense so I just did a
>
> # for i in each-of-the-disks; do
> sfdisk -uS /dev/sd$i << EOF
> partition info
> EOF
> done
>
> and all was well.
>
> The concept of cylinder et. al is history now. Only the manufacturer
> knows how the info is organized on the disk surface.

Thanks a lot! Just tried again and this time it worked.
Dunno why the system oopsed the first time.

Thomas
