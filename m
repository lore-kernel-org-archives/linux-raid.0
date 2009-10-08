From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: NAS Remote Side of a Mirror
Date: Thu, 08 Oct 2009 14:10:11 +0100
Message-ID: <4ACDE4B3.7000007@anonymous.org.uk>
References: <656255.26746.qm@web38802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <656255.26746.qm@web38802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/10/2009 13:15, adfas asd wrote:
> --- On Thu, 10/8/09, John Robinson <john.robinson@anonymous.org.uk> wrote:
>> Hang on - you still need Samba to export a Linux filesystem
>> to Windows clients, don't you? And that's what a NAS has to
>> do.
> 
> Winduhs clients?  We don't need no steenkin' Winduhs clients...

In which case no, you don't need Samba, you never did need Samba and 
I've no idea why you were using it.

The QNAP NAS you linked to does export filesystems via SMB using Samba, 
as well as via AFS, NFS, FTP and HTTP. It can also export volumes via 
iSCSI. It almost certainly runs LVM over md RAID to do all these things.

If you want to build a box to put in your garage which exports raw discs 
over ethernet, you might want to consider nbd (Network Block Device) or 
similar, or iSCSI. If you want it to export files, you will need to run 
a filesystem and expose them using Samba, AFS or NFS, depending on your 
client and preference.

I have a box in my hall cupboard which has 3 1TB discs. They're 
partitioned into two partitions each. The first partitions make up md0 
with RAID-1 which mounts as /boot in the Xen dom0. The second partitions 
make up md1 with RAID-5 with a write-intent bitmap, over which I run 
LVM, which has logical volumes for the Xen dom0 root filesystem, various 
other Xen guests' filesystems, and a large filestore. The filestore 
volume is formatted ext3 and exported to the network with Samba to 
Windows clients and NFS to Linux clients. Fast clients also using 
gigabit ethernet manage ~80MB/s reading and ~60MB/s writing large files 
over either SMB or NFS. The machine also runs a MythTV backend. I have 
done some performance tuning to get where I am, some of it discussed on 
this list, and now I have no performance problems, and just look at all 
those layers...

Cheers,

John.
