From: Derek Vadala <derek@vadala.com>
Subject: Re: mdadm -c magic?
Date: Thu, 20 Feb 2003 13:00:14 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030220180014.2B2173B809@jaded.cynicism.com>
References: <20030220164443.GG19609@rdlg.net>
Reply-To: derek@vadala.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030220164443.GG19609@rdlg.net>
To: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 20 Feb 2003, Robert L. Harris wrote:

> Is it possible to have mdadm make the array and just leave the one spot
> open anyway?  I tried a few options:
>
> root@legato-disk5.acs:~# mdadm -C -c 128  -l 5 -p left-asymmetric -n 4 -x 0=
>  /dev/md3 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
> [snip]
> mdadm: create aborted
> root@legato-disk5.acs:~# mdadm -C -c 128  -l 5 -p left-asymmetric -n 4 -x 0=
>  /dev/md3 /dev/sdm1 /dev/sdn1 /dev/sdo1
> mdadm: You haven't given enough devices (real or missing) to create this ar=
> ray

Try using the keyword 'missing' in place of a real disk or partition:

# mdadm -C /dev/md3 -c 128 -l 5 -n 4 /dev/sdm1 /dev/sdn1 /dev/sdo1 missing

That should give you a 3-disk RAID-5 in degraded mode. I think that's what
you want. Add the fourth disk when it shows up and the array will
resync.

