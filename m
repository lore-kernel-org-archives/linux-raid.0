From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: 3-way mirror to RAID-6
Date: Tue, 26 Dec 2017 10:09:45 +0000
Message-ID: <5A421FE9.8000200@youngman.org.uk>
References: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
 <87incu79uw.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87incu79uw.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25/12/17 21:53, NeilBrown wrote:
> On Mon, Dec 25 2017, Gandalf Corvotempesta wrote:
> 
>> Hi to all
>> I have a server with a 3way mirror.
>> As I have to increase the total available space, one solution would be to
>> replace all disks with bigger ones, but this is expensive.
>>
>> Another solution would be to add just one disk and then reshape from
>> RAID-1 to RAID-6
>>
>> Do you have any guide on how to do this reshape on a running array ?
>> Thank you.
> 
> I suggest you add the new device with "mdadm --add", then try the
> reshape with "mdadm --grow /dev/mdXXX --level=6 --raid-devices-4".
> 
> It might not work quite that easily - I think you need to first convert
> the raid1 to a 2-way mirror, but that is easy enough
> 
>  mdadm --grow /dev/mdxxx --raid-devices=2

That was my reaction. I'm 99% certain that a three-way will not reshape.
> 
> NeilBrown
> 
Cheers,
Wol
