From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Fri, 28 Apr 2017 09:11:45 +0200
Message-ID: <CAHKno4DBXT5n7wYosie_WHBhzXnHj0CFkdjv7_VAN2NVF-Ng4g@mail.gmail.com>
References: <20170424123706.GA6798@metamorpher.de> <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de> <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de> <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de> <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de> <5c3f7876-1b25-7020-5e7d-01776e7c9903@powerlamerz.org>
 <20170427231242.GA5138@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170427231242.GA5138@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-28 1:12 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Thu, Apr 27, 2017 at 09:57:20PM +0200, Patrik Dahlstr=C3=B6m wrote:
>> Success! Using a 126M as data offset gave me valid data for the 5 disk
>> raid and using linear device mapping I'm able to access my data again.
>
> Nice.
>
>> Some is probably corrupted from my previous destructive recovery
>> attempts, but it seems like most of the data is still there and
>> accessible. I will start backup up the most essential data now.
>
> If nothing else happened, I'd expect it to be intact (or at least
> not any more corrupt than it would be after a regular power loss).
> If you encounter any files with corrupted contents, you could use
> `filefrag` or `hdparm --fibmap` to determine where it is physically
> located and then perhaps see if that's anywhere near your danger zone.
> It could still mean you didn't choose the correct X for linear mapping.
>
> But of course, I don't know everything that happened. :-P

During some of my experiments, reshaping was triggered with wrong
metadata. This corrupted my data. I'm gonna ignore this and let fsck
solve it. I already tried it with overlays and linear device mapping.
>
>> > This is only a way to get read access at the data, making the raid
>> > work as a standalone again (resume reshape with lost raid metadata)
>> > is another problem, to be tackled after you backed up your data ;)
>>
>> Now, how do we do this?
>
> Well, there's an elegant approach that works beautifully and perfectly
> and entirely risk free... and then there's a simple, stupid, quick&dirty.
> Only problem is, I'm way too lazy to describe the elegant one. Shucks.
Ha!
>
> The quick and dirty method is... grow using dd from 5disk raid (overlay)
> to 6disk raid (no overlay) starting from the correct offset (verify!).
> That resumes your reshape in an offline-ish, hackish manner, and once
> it's done you have the whole thing. That's the theory anyway.
>
> Pseudocode:
>
> mdadm --create /dev/md5 --assume-clean /dev/overlay/{a,b,c}
> mdadm --create /dev/md6 --assume-clean /dev/{a,b,c,d} # +1 drive
> losetup --offset=3DX /dev/loop55 /dev/md5
> losetup --offset=3DX /dev/loop66 /dev/md6
> cmp /dev/loop55 /dev/loop66 # much identical, so wow
> dd bs=3D1M status=3Dprogress if=3D/dev/loop55 of=3D/dev/loop66
Is it missing a 'skip=3D<offset/1M>'  here?
>
> It's dangerous, okay?
> I didn't tell you to do it, okay?
> Don't blame me, okay?
> Backup your stuff first, okay?
Ha!
>
> As this writes to your drives, you have only one shot to get it right.
> You're not allowed to mount until dd is done. It's an offline operation.
> If dd were to be aborted for any reason, the offset would shift to X+n.
> If dd were to encounter write errors without aborting, corruption ensues.
Swell!
>
> Regards
> Andreas Klauer
>

Thanks a lot. I will try this later.
