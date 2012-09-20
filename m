From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: Small short question Was: Re: Recovering from the kernel bug,
 Neil?
Date: Thu, 20 Sep 2012 19:05:33 +0200
Message-ID: <505B4CDD.7010509@schinagl.nl>
References: <5030F07F.7000303@schinagl.nl> <504CFA7B.7090606@schinagl.nl> <20120910090829.19100cdf@notabene.brown> <504DA85C.6080000@schinagl.nl> <20120911161622.0b0fcf8c@notabene.brown> <505301E1.10707@schinagl.nl> <50531A52.7060205@schinagl.nl> <20120920122218.07f89443@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120920122218.07f89443@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20-09-12 04:22, NeilBrown wrote:
> On Fri, 14 Sep 2012 13:51:46 +0200 Oliver Schinagl <oliver+list@schinagl.nl>
> wrote:
>
>> Since I had only one valid device to check with etc, I assume that if
>> fsck -n -f /dev/md2 runs sucessfully, it is 100% safe to assume the
>> array is perfectly healthy?
> I might be a bit late here but....
>
> No, not 100% safe.
> I would at least mount the filesystem and have a look around - take a random
> sample and see if it all looks credible.  If it does then that is as good as
> it gets.
I did check the FS, I ran some fsck tests and checked data on the drive, 
everything appeared to be normal. I still have to verify some 
unimportant iso images, once that is done, I cannot imagine the data 
being bad.
>
>> E.g. it should be perfectly safe to mdadm --zero-superblock on /dev/sda6
>> and add it to /dev/md2 (missing /dev/sdb6)?
>>
>> I know technically this all works out fine, and the bug shouldn't have
>> broken anything in that regard. Or is it absolutly recommended to simply
>> create a new array, with a new FS on it, and copy all data over
>> (Logically also with /dev/md2, /dev/sda6 missing and later adding sdb6)?
> Creating a new array shouldn't be necessary.  In general I would avoid
> copying data when convenient.
I didn't think it would have mattered. The meta-data is rewritten so if 
data is good, everything is good. Since I added an empty disk to the 
'half' array, everything is re-synced and a-ok.
> NeilBrown

