From: Jesse Wheeler <jwwstpete@gmail.com>
Subject: Re: Random MD Raid resyncs?
Date: Mon, 2 Nov 2009 18:40:59 -0500
Message-ID: <f1ef83020911021540i4094fa1dqc87a6ff0b5b675f0@mail.gmail.com>
References: <f1ef83020911020655kf8935c5icf9aea31edb03c57@mail.gmail.com>
	 <f1ef83020911020657w1494e31ao716203f9fb9f0d8f@mail.gmail.com>
	 <155cc2abd59adbec8b109a0602d7431d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <155cc2abd59adbec8b109a0602d7431d.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil:

Thanks for the help.

AFAIK, any of the RAID devices are not mounted 'auto-read-only' by the
kernel.  I'll double check /etc/fstab, /var/log/messages, and
/var/log/dmesg when I get back to the site.  Unless there was a change
by the upstream vendor, I wouldn't mount a production filesystem in
that manner.  Of course, I've been surprised before!

I'll double check and report back.  Thanks again for the suggestion!

On Mon, Nov 2, 2009 at 5:23 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, November 3, 2009 1:57 am, Jesse Wheeler wrote:
>> All:
>>
>> Thanks for the invaluable resource that is this mailing list. =A0I'v=
e
>> learned quite a bit over the space of this month.
>>
>> I have the following configuration and question:
>>
> .....
>>
>> Nov =A02 09:15:42 fatboy dnsmasq[3648]: exiting on receipt of SIGTER=
M
>> Nov =A02 09:15:43 fatboy dnsmasq[6922]: started, version 2.45 caches=
ize 150
>> Nov =A02 09:15:43 fatboy dnsmasq[6922]: compile time options: IPv6
>> GNU-getopt no-ISC-leasefile no-DBus no-I18N TFTP
>> Nov =A02 09:15:43 fatboy dnsmasq[6922]: using local addresses only f=
or
>> domain devotioconsulting.net
>> Nov =A02 09:15:43 fatboy dnsmasq[6922]: using nameserver 208.67.220.=
220#53
>> Nov =A02 09:15:43 fatboy dnsmasq[6922]: using nameserver 208.67.222.=
222#53
>> Nov =A02 09:15:43 fatboy dnsmasq[6922]: read /etc/hosts - 14 address=
es
>> Nov =A02 09:21:04 fatboy kernel: md: syncing RAID array md1
>
> The only possible explanation for this that I can think
> of is the the array was started in 'auto-read-only' mode in which
> it will not write to the devices at all until a write request comes i=
n
> through the top level device. =A0Once that write request arrives, md =
accepts
> that the array really is meant to be used and starts any resync etc t=
hat
> might be needed.
>
> How is /dev/md1 used? =A0Is it possible that nothing tried to
> write to it until this moment?
>
> If it was something started by a cron job, it would not say
> "resync =3D" but rather 'check =3D' or 'repair =3D'.
>
> NeilBrown
>
>
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
