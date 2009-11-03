From: Jesse Wheeler <jwwstpete@gmail.com>
Subject: Re: Random MD Raid resyncs?
Date: Tue, 3 Nov 2009 13:25:12 -0500
Message-ID: <f1ef83020911031025s70f3c832qebf8ae2f16318b71@mail.gmail.com>
References: <f1ef83020911020655kf8935c5icf9aea31edb03c57@mail.gmail.com>
	 <f1ef83020911020657w1494e31ao716203f9fb9f0d8f@mail.gmail.com>
	 <155cc2abd59adbec8b109a0602d7431d.squirrel@neil.brown.name>
	 <f1ef83020911021540i4094fa1dqc87a6ff0b5b675f0@mail.gmail.com>
	 <20091103100528.GG24791@boogie.lpds.sztaki.hu>
	 <f1ef83020911030644j140c1cfft81540ddd769a46f7@mail.gmail.com>
	 <20091103154513.GM24791@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091103154513.GM24791@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Understood.  I've actually done some googling since my last e-mail
reading about your suggestion.  It's quite fascinating to me.  I'll
keep an eye on this machine for the time being and stick with some
multi-level backup until my confidence level goes back up.

Thanks everyone for the insight.

On Tue, Nov 3, 2009 at 10:45 AM, Gabor Gombas <gombasg@sztaki.hu> wrote=
:
> On Tue, Nov 03, 2009 at 09:44:50AM -0500, Jesse Wheeler wrote:
>
>> Interesting. =A0I just got done reading that section in the manpage;=
 if
>> anything, I didn't know mdadm would process an array in that fashion=
=2E
>> However, I don't see this behavior listed in my /proc/mdstat output.
>> If it's there, I'm missing it:
>
> auto-read-only goes away with the first write request. If you have a
> file system on the RAID device, just mounting it R/W causes the super=
block
> to be updated and that in turn ends auto-read-only mode. Unless you h=
ave
> an unused RAID device, it's not that easy to catch the moment when th=
e
> array is still in auto-read-only mode.
>
> Gabor
>
> --
> =A0 =A0 ---------------------------------------------------------
> =A0 =A0 MTA SZTAKI Computer and Automation Research Institute
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Hungarian Academy of Sciences
> =A0 =A0 ---------------------------------------------------------
>



--=20
Jesse W. Wheeler
mailto: jwwstpete@gmail.com
Charlotte, North Carolina - U.S.A.

=3D=3D
"I'm a white male, age 18 to 49. Everyone listens to me, no matter how
dumb my suggestions are." --Homer Simpson

"I really don't understand how bipartisanship is ever going to work
when one of the parties is insane."-- John Cole

"I defy the tyranny of precedent. I cannot afford the luxury of a
closed mind. I go for anything new that might improve the past." --
Clara Barton

"Any dictator would admire the uniformity and obedience of the U.S.
media." -- Noam Chomsky

"We are called to speak for the weak, for the voiceless, for victims
of our nation and for those it calls enemy...". -- Martin Luther King,
"Beyond Vietnam"

"Be yourself; everyone else is already taken." - Oscar Wilde

* My Other Car is a Health Insurance Payment
* My Car Has Better Insurance Than I Do
* My Death Panel is an HMO
* Underinsured Baby on Board
* WWJD:   Who Would Jesus Deny? (Healthcare Reform Now!)

"Quitbull with Lipstick: She's a gift that keeps on giving; an
Everlasting Gobstopper of fail." -- SilentBrook on DKos talking about
Palin
=3D=3D
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
