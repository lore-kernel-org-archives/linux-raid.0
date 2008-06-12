From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: RAID5 losing initial synchronization on restart when one disk is spare
Date: Thu, 12 Jun 2008 10:01:46 -0700
Message-ID: <e9c3a7c20806121001p516bdb24kb60ec32d7f9bd4a9@mail.gmail.com>
References: <48466AD9.5@free.fr> <18512.25477.431367.952164@notabene.brown>
	 <4850D86C.70402@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4850D86C.70402@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, Hubert Verstraete <hubskml@free.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 12, 2008 at 1:03 AM, David Greaves <david@dgreaves.com> wrote:
> Neil Brown wrote:
>> When writing to the array, the new parity block will sometimes be
>> calculated assuming that it was previously correct.  If all updates to
>> a particular parity block are of this sort, then it will still be
>> incorrect when you lose a drive, and data recovered based on that
>> parity block will be incorrect.
>>
>> Until you lose a drive, it will have no visible effect.
>
> There is a slight chance that this happened to me recently - would a
>  echo check > /sys/block/mdX/md/sync_action
> detect this?
> and would
>  echo repair > /sys/block/mdX/md/sync_action
> fix it?
>

'Yes' on both questions.

--
Dan
