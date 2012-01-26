From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: Re: disk-sleep problems
Date: Thu, 26 Jan 2012 15:54:08 -0600
Message-ID: <20120126155408.71fa0bd1@pog.tecnopolis.ca>
References: <CACFydqtrYbjCqzic-ke0B69abWyCpXoFm+3ge=EaBc9GvvgnWg@mail.gmail.com>
	<20256.12185.952242.330030@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20256.12185.952242.330030@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: wrl.delvaux@gmail.com
List-Id: linux-raid.ids

On 2012-01-25 Peter Grandi wrote:
> >>> On Tue, 17 Jan 2012 01:09:34 +0100, Wim Delvaux
> >>> <wrl.delvaux@gmail.com> said:
> 
> > Hi all, I have two 2TB disks half set up using raid 1 (full
> > mirroring ?) and the other half using striping. very
> > frequently my system, a kubuntu 11.10, hangs (gui is

Hi, are your disks WD "Caviar Green" drives?  There were big problems
with the EADS drives (and maybe more) that would cause them to
basically become useless 1MB/s drives after X months of use.  I've seen
it personally.

Search on "WD Green 1MB/s slow".

Buy a new 2TB, dd the contents over with RAID off, or let md
re-mirror.  Wait a few days for it to finish if the bug hits...

If you don't have a EADS drive then your problem is likely as Peter
outlines.
