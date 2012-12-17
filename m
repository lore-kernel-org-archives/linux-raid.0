From: Alex Pientka <alex.pientka@gmail.com>
Subject: Re: strange partition table and slow speeds
Date: Mon, 17 Dec 2012 16:16:07 -0500
Message-ID: <CA+Z7oPhX2+soO_DH8vibBWz=C1vsvajTgUqNGOACLGxNDAjZxw@mail.gmail.com>
References: <CA+Z7oPgx6DgEbpJ6OEoMFTDbUPhq_b4UXp8SW-dPiVNYw17bjA@mail.gmail.com>
 <28361073.8.1355777233170.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28361073.8.1355777233170.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

I want to understand why my partition table is suddenly different
moving it from one system to a different one. This happened after I
moved the 6 drives from one system to the new system.

Is this the reason why I suddenly have such bad performance?
Alex


On Mon, Dec 17, 2012 at 3:47 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.ne=
t> wrote:
> why would you want to use partitions for such a RAID in the first pla=
ce?
>
> ----- Opprinnelig melding -----
>> That brings up the question: Any reason to get the partition table
>> fixed up? Is this just a cosmetic issue?
>> Alex
>>
>>
>> On Mon, Dec 17, 2012 at 12:41 PM, Phil Turmel <philip@turmel.org>
>> wrote:
>> > [Top-posting repaired. Please don't.]
>> >
>> > On 12/17/2012 12:26 PM, Alex Pientka wrote:
>> >> On Mon, Dec 17, 2012 at 12:18 PM, Phil Turmel <philip@turmel.org>
>> >> wrote:
>> >>> Hi Alex,
>> >>>
>> >>> On 12/17/2012 09:17 AM, Alex Pientka wrote:
>> >>>
>> >>> [trim /]
>> >>>>
>> >>>> /dev/md0:
>> >>>>         Version : 1.1
>> >>>
>> >>>                    ^^^^^
>> >>> You've deliberately chosen a metadata version that places the
>> >>> superblock
>> >>> at sector 0 of the given device. If that is a whole disk, it
>> >>> overwrites
>> >>> the partition table. The default metadata is v1.2 (which places
>> >>> the
>> >>> superblock at offset 4k) for this very reason.
>> >
>> >> I assume upgrading to v1.2 is not possible. The only other way
>> >> would
>> >> be to fail every raw device (one-by-one) and then create the fd
>> >> partition on it, correct?
>> >
>> > You could put the array back on partitions if you like. I'd make a
>> > complete backup, zero the superblocks, and use --create
>> > --assume-clean
>> > to switch to v1.2 in place (with due care to maintain the device
>> > order
>> > and data offsets).
>> >
>> > (Save the output of "mdadm -E /dev/sdXX" for each member device
>> > before
>> > you start.)
>> >
>> > However, that fdisk can't understand the partition table shouldn't
>> > be
>> > hurting anything, so I wouldn't make it a priority.
>> >
>> > BTW, partition type 'fd' is deprecated along with v0.90 metadata, =
as
>> > it
>> > only impacts kernel non-initramfs autoassembly, and that only work=
s
>> > with
>> > DOS partition tables and v0.90 metadata.
>> >
>> > Phil
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> --
> Vennlige hilsener / Best regards
>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> roy@karlsbakk.net
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibel=
t. Det er et element=E6rt imperativ for alle pedagoger =E5 unng=E5 ekse=
ssiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller=
 eksisterer adekvate og relevante synonymer p=E5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
