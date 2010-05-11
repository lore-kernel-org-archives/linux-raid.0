From: Aryeh Gregor <Simetrical+list@gmail.com>
Subject: Re: layout of far blocks in raid10
Date: Tue, 11 May 2010 18:22:58 -0400
Message-ID: <AANLkTikJte4n45uDZfKCXF1z-uuVmBhpN3qHPJz19pvV@mail.gmail.com>
References: <20100511151204.GA3781@rap.rap.dk>
	 <AANLkTimKPeTgUGLosNXJScE73agrlxL8NgO0W44OwlVh@mail.gmail.com>
	 <20100512075656.45257d16@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100512075656.45257d16@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Keld Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 11, 2010 at 5:56 PM, Neil Brown <neilb@suse.de> wrote:
> I'm not quite sure how to respond to this... =C2=A0As a mathematician=
 I would
> expect you to understand the important of precision in choosing words=
, yet
> you use the word "know" for something that is exactly wrong. =C2=A0Ei=
ther you mean
> "guess" or you have been seriously misinformed. =C2=A0If it is the la=
tter, then
> please let me know where this misinformation came from so I can see a=
bout
> getting it corrected.
>
> md/raid10 uses a simple cyclic layout in all cases. =C2=A0It does so =
because this
> layout is completely general and works for all numbers of devices and=
 copies.
>
> So you can only survive multiple device failures where are most N-1 a=
re
> adjacent where N is the number of copies, and the first and last devi=
ces are
> treated as adjacent.

Mathematicians are sometimes wrong too, sadly.  :)  (And I'm only a
grad student!)  I believe this is where I got my info:

http://git.debian.org/?p=3Dpkg-mdadm/mdadm.git;a=3Dblob_plain;f=3Ddebia=
n/FAQ;hb=3DHEAD

The answer to question 20 of that suggests that if you have four
disks, 0 1 2 3, then 0 and 1 form one pair and 2 and 3 form the other.
 If 2 fails, then 0 or 1 could still fail without data loss, but a
failure of 3 will cause data loss.  Obviously, you know what you're
talking about better than a Debian FAQ, so unless I'm misunderstanding
the FAQ or you or both, maybe you should talk to the author of that.

Testing with loopback files does seem to show that failing the second
and third drives in a four-drive RAID will cause the RAID to fail, as
I would predict from what you say and contrary to what I interpreted
that FAQ to mean, so hopefully now I understand correctly.

Thanks for the correction.  Next time I'll be more cautious.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
