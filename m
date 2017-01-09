From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Interesting mdadm quirk ...
Date: Mon, 9 Jan 2017 06:59:50 +0000
Message-ID: <587334E6.406@youngman.org.uk>
References: <5870EB3F.2060206@youngman.org.uk>
 <87mvf1jhnu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mvf1jhnu.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: jes.sorensen@redhat.com
List-Id: linux-raid.ids

On 08/01/17 22:44, NeilBrown wrote:
> On Sun, Jan 08 2017, Wols Lists wrote:
> 
>> Just been doing some raid testing, and this happened ...
>>
>> linux-lfqf:/dev # mdadm md/parity
>> md/parity: 31.97GiB raid5 3 devices, 0 spares. Use mdadm --detail for
>> more detail.
>> linux-lfqf:/dev # mdadm --stop md/parity
>> mdadm: Cannot open md/parity
>> linux-lfqf:/dev # mdadm --stop /dev/md/parity
>> mdadm: stopped /dev/md/parity
>>
>> Weird - why can it successfully stop it when passed an absolute path,
>> but not when passed a relative path? When I did the first variant, I
>> used tab completion, and then when I edited it I really did edit it, not
>> retype it, so I can't see any way the two arguments could refer to
>> different objects.
> 
> If you give mdadm a name of an array that start with "/", it is assumed
> to be a path name (usually in /dev).
> If it doesn't start with "/", then it is an array name.  The might mean
> different things in different contexts, I'm not 100% sure.
> However, for --stop, it a name like you would find is /sys/block or
> /proc/mdstat.
> So "mdadm --stop md0" or "mdadm --stop md_parity" might do what you
> want.
> Probably the error message could be more useful here.
> 
Does that mean an array name can contain a "/"?

Assuming it can't, surely it's better to alter the logic slightly...

if char[0] ne '/' then
  open array_name
end
if not successful then
  open path_name
  if error then go error_handler
end
carry on ...

That way naive users like me won't get a surprise. And it is rather
inconsistent for it to work with one sort of path but not another ...
and actually that logic will work fine even if the name does contain a
"/" :-)

Cheers,
Wol

