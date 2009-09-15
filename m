From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Tue, 15 Sep 2009 20:02:41 +0300
Message-ID: <70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>
	<h8nrkn$n8p$5@ger.gmane.org> <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias,

Out of curiosity, how will you find the sectors/blocks that
reconstruct a certain bad sector? Is the data spread to the same block
number on all disks?

On Tue, Sep 15, 2009 at 2:03 PM, Majed B. <majedb@gmail.com> wrote:
> I've been trying to migrate for 2 weeks. I can wait another 2 ... may=
be 3 weeks.
>
> Just to be clear, I'm using dd_rescue, not ddrescue (This is the GNU
> one). I read the log option but forgot to use it... now I've wasted
> over 20 hours... ugh ... /smacks self
>
> That would be a very useful program for cases like this!
>
> On Tue, Sep 15, 2009 at 1:52 PM, Matthias Urlichs <matthias@urlichs.d=
e> wrote:
>> On Tue, 15 Sep 2009 13:40:44 +0300, Majed B. wrote:
>>
>>> Would anyone suggest a better solution?
>>
>> You should tell ddrescue to log which sectors it failed to copy. You=
 can
>> then recover the missing data by reading the stuff at that offset fr=
om
>> the other disks, and XORing the bytes.
>>
>> I plan to write a program which does that (and which also understand=
s
>> RAID1 and RAID6). How long can you survive without your data?
>>
>> --
>> Matthias Urlichs
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0 Majed B.
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
