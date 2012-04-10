From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Intel fakeraid working?
Date: Tue, 10 Apr 2012 09:14:58 -0400
Message-ID: <4F843252.5090109@ubuntu.com>
References: <4F7CEDD0.9080904@ubuntu.com> <20120405111317.2a5227b1@notabene.brown> <4F7DE314.9040306@ubuntu.com> <20120406092428.1090e10b@notabene.brown> <4F7E426F.5000604@ubuntu.com> <20120410094330.00fb2477@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120410094330.00fb2477@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/9/2012 7:43 PM, NeilBrown wrote:
> It will reject writes from user-space, and it will reject attempts to mount a
> filesystem unless the filesystem is mounted "read-only".
> But if a read-only mounted filesystem decides to write anyway (XFS, ext3,
> ext4...) then the block layer doesn't stop it.

How does that work?  How does the block layer know or care what mount 
flags are used?  My understanding is that setting the block layer 
read-only flag with blockdev --setro actually causes the write bios to 
be rejected, thus preventing ext[34] from playing back the journal. 
Ubuntu has been using this to prevent accidental damage by read-only 
mounts since this abhorrent behavior was discovered.  I would think that 
md should work the same way.


