From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2] Avoid OOPS when reshaping raid1 to raid0
Date: Tue, 27 Mar 2012 09:17:46 +0200
Message-ID: <4F71699A.4090809@redhat.com>
References: <1332750685-31643-1-git-send-email-Jes.Sorensen@redhat.com> <20120327143539.32cedf3c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120327143539.32cedf3c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/27/12 05:35, NeilBrown wrote:
> On Mon, 26 Mar 2012 10:31:25 +0200 Jes.Sorensen@redhat.com wrote:
> 
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> raid1 arrays do not have the notion of chunk size. Calculate the
>> larges chunk sector size we can use to avoid a divide by zero OOPS
>> when aligning the size of the new array to the chunk size.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Thanks.
> Applied with one change:
> 
>>  	/* Set new parameters */
>>  	mddev->new_level = 0;
>>  	mddev->new_layout = 0;
>>  	mddev->new_chunk_sectors = 128; /* by default set chunk size to 64k */
> 
> I changed the above line to
> 	mddev->new_chunk_sectors = chunksect;
> 
> as that makes more sense.

I agree, I was wondering whether to change it as well.

Thanks - will it be in your git repo soon?

Cheers,
Jes
