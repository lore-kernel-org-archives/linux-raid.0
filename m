From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 05/11] md/raid5: add scribble region for buffer lists
Date: Wed, 20 May 2009 12:05:58 -0700
Message-ID: <e9c3a7c20905201205j621c6d50ib3b86370eae3696f@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005951.4104.27062.stgit@dwillia2-linux.ch.intel.com>
	 <20090520080910.GU6403@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090520080910.GU6403@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 20, 2009 at 1:09 AM, Andre Noll <maan@systemlinux.org> wrot=
e:
> On Mon, May 18, 2009 at 05:59:51PM -0700, Dan Williams wrote:
>
>> +static size_t scribble_len(int num)
>> +{
>> + =A0 =A0 size_t len;
>> +
>> + =A0 =A0 /* return enough space for an array of page pointers and d=
ma
>> + =A0 =A0 =A0* addresses for the ddf raid6 layout
>> + =A0 =A0 =A0*/
>> + =A0 =A0 len =3D sizeof(struct page *) * (num+2) + sizeof(addr_conv=
_t) * (num+2);
>> +
>> + =A0 =A0 return len;
>> +}
>
> The comment is a bit misleading as the function only returns the
> _amount_ of space needed. It should probably also explain the meaning
> of the "+2".

Ok I updated this to:
/**
 * scribble_len - return the required size of the scribble region
 * @num - total number of disks in the array
 *
 * The size must be enough to contain:
 * 1/ a struct page pointer for each device in the array +2
 * 2/ room to convert each entry in (1) to its corresponding dma
 *    (dma_map_page()) or page (page_address()) address.
 *
 * Note: the +2 is for the destination buffers of the ddf/raid6 case wh=
ere we
 * calculate over all devices (not just the data blocks), using zeros i=
n place
 * of the P and Q blocks.
 */

>
>> +/* return a pointer to the address conversion region of the scribbl=
e buffer */
>> +static addr_conv_t *sh_to_addr_conv(struct stripe_head *sh)
>> +{
>> + =A0 =A0 return sh->scribble + sizeof(struct page *) * (sh->disks +=
 2);
>> +}
>
> Maybe it's safer to return NULL if sh->scribble is NULL.

=2E..yes, and a big fat warning, because it should never be NULL.

Thanks for the review,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
