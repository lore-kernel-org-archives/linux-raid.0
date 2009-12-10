From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [Ocfs2-users] Combining OCFS2 with Linux software RAID-0?
Date: Thu, 10 Dec 2009 11:40:43 -0800
Message-ID: <4B214EBB.2060407@oracle.com>
References: <23986fd90912091503r3c671448va4d8637edfab472b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23986fd90912091503r3c671448va4d8637edfab472b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: ocfs2-users@oss.oracle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It should work. All ocfs2 needs is a stable shared storage that
is consistent across all nodes all the time.

Patrick J. LoPresti wrote:
> Is it possible to run an OCFS2 file system on top of Linux software RAID?
>
> Here is my situation.  I have four identical disk chassis that perform
> hardware RAID internally.  Each chassis has a pair of fiber channel
> ports, and I can assign the same LUN to both ports.  I want to connect
> all of these chassis to two Linux systems.  I want the two Linux
> systems to share a file system that is striped across all four chassis
> for performance.
>
> I know I can use software RAID (mdadm) to do RAID-0 striping across
> the four chassis on a single machine; I have tried this, it works
> fine, and the performance is tremendous.  I also know I can use OCFS2
> to create a single filesystem on a single chassis that is shared
> between my two Linux systems.  What I want is to combine these two
> things.
>
> Suse's documentation
> (http://www.novell.com/documentation/sles11/stor_admin/?page=/documentation/sles11/stor_admin/data/raidyast.html)
> says:
>
> "IMPORTANT:Software RAID is not supported underneath clustered file
> systems such as OCFS2, because RAID does not support concurrent
> activation. If you want RAID for OCFS2, you need the RAID to be
> handled by the storage subsystem."
>
> Because my disk chassis already perform hardware RAID-5, I only need
> Linux to do the striping (RAID-0) in software.  So for me, there is no
> issue about "which node should rebuild the RAID" etc.  I understand
> that Linux md stores meta-data on the partitions and is not cluster
> aware, but will this create problems for OCFS2 even if it is just RAID
> 0?
>
> Has anybody tried something like this?  Are there alternative RAID-0
> solutions for Linux that would be expected to work?
>
> Thank you.
>
>  - Pat
>
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-users
>   

