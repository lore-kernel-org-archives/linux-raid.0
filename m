From: Derek Vadala <derek@cynicism.com>
Subject: Re: Manually fail a disk?
Date: Sun, 19 Jan 2003 09:43:21 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030119144321.D9B7E3B808@jaded.cynicism.com>
References: <20030119132953.GA18651@rdlg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030119132953.GA18651@rdlg.net>
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>   I've got a disk that's starting to fail hard.  It's generating alot of
> errors in dmesg and /var/log/messages.  If the raid disk gets any usage
> it'll lock up the box it's spewing errors so fast.  I can't get out to
> physically yank the disk until Tues but need it off-lined now.  Is there
> a way to tell mdtools (version 0.42-33) to mark a disk faulty and not
> use it?

I'll assume this is a RAID-1 or RAID-5 and that you're not trying this on
a non-redundant array...


# mdadm /dev/md0 --fail /dev/sda1
# mdadm /dev/md0 --remove /dev/sda1

The first command fails /dev/sda1 (a member of /dev/md0) and the second
command removes it from /dev/md0.

If you are using raidtools try:

# raidsetfaulty /dev/md0 /dev/sda1
# raidhotremove /dev/md0 /dev/sda1

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

