From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sat, 20 Apr 2013 03:53:49 +0200
Message-ID: <5171F52D.4040701@bucksch.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <516FFC13.2030803@ultratux.net> <5171CB91.1040708@bucksch.org> <5171EED3.8030505@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5171EED3.8030505@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben Bucksch wrote, On 20.04.2013 03:26:
> I can read my files again, without problem, all is happy. 

Actually, no. XFS filesystem structure is not sane. I must have done 
something wrong. (If possible, please let me know what, all data should 
be posted.)

At first, it looked OK, as if only one recently written directory was 
broken. I unmounted one of the FS, did xfs_repair, and after 
re-mounting, almost all directories are gone. Almost 100% dataloss. I 
can't describe how upset I am against md.

Oh, and in case you're wondering about my backup: That's gone, too, due 
to bugs in btrfs that trashed the FS and also stopped the dedicated 
backup machine from booting automatically, so I don't have any current 
backup either.

Ben
