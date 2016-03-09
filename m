From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 6/8] bitmap: Fix resource leak in bitmap_file_open()
Date: Wed, 09 Mar 2016 11:28:46 -0500
Message-ID: <wrfja8m7vcn5.fsf@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
	<1457458252-20203-7-git-send-email-Jes.Sorensen@redhat.com>
	<87a8m8lh2t.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8m8lh2t.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Wed, 09 Mar 2016 09:50:50 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> The code would leak 'fd' if locate_bitmap() failed.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>  bitmap.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/bitmap.c b/bitmap.c
>> index 5ad7401..0367d13 100644
>> --- a/bitmap.c
>> +++ b/bitmap.c
>> @@ -224,6 +224,7 @@ int bitmap_file_open(char *filename, struct supertype **stp, int node_num)
>>  		} else {
>>  			if (st->ss->locate_bitmap(st, fd, node_num)) {
>>  				pr_err("%s doesn't have bitmap\n", filename);
>> +				close(fd);
>>  				fd = -1;
>>  			}
>>  		}
>
> Don't you also need a 'close' in
>
> 		} else if (!st->ss->locate_bitmap) {
> 			pr_err("No bitmap possible with %s metadata\n",
> 				st->ss->name);
> 			return -1;
> ??

I probably need new glasses too :)

Thanks for catching that!

Cheers,
Jes
