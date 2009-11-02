From: "NeilBrown" <neilb@suse.de>
Subject: Re: Random MD Raid resyncs?
Date: Tue, 3 Nov 2009 09:23:55 +1100
Message-ID: <155cc2abd59adbec8b109a0602d7431d.squirrel@neil.brown.name>
References: <f1ef83020911020655kf8935c5icf9aea31edb03c57@mail.gmail.com>
    <f1ef83020911020657w1494e31ao716203f9fb9f0d8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f1ef83020911020657w1494e31ao716203f9fb9f0d8f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Wheeler <jwwstpete@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, November 3, 2009 1:57 am, Jesse Wheeler wrote:
> All:
>
> Thanks for the invaluable resource that is this mailing list. =A0I've
> learned quite a bit over the space of this month.
>
> I have the following configuration and question:
>
=2E....
>
> Nov =A02 09:15:42 fatboy dnsmasq[3648]: exiting on receipt of SIGTERM
> Nov =A02 09:15:43 fatboy dnsmasq[6922]: started, version 2.45 cachesi=
ze 150
> Nov =A02 09:15:43 fatboy dnsmasq[6922]: compile time options: IPv6
> GNU-getopt no-ISC-leasefile no-DBus no-I18N TFTP
> Nov =A02 09:15:43 fatboy dnsmasq[6922]: using local addresses only fo=
r
> domain devotioconsulting.net
> Nov =A02 09:15:43 fatboy dnsmasq[6922]: using nameserver 208.67.220.2=
20#53
> Nov =A02 09:15:43 fatboy dnsmasq[6922]: using nameserver 208.67.222.2=
22#53
> Nov =A02 09:15:43 fatboy dnsmasq[6922]: read /etc/hosts - 14 addresse=
s
> Nov =A02 09:21:04 fatboy kernel: md: syncing RAID array md1

The only possible explanation for this that I can think
of is the the array was started in 'auto-read-only' mode in which
it will not write to the devices at all until a write request comes in
through the top level device.  Once that write request arrives, md acce=
pts
that the array really is meant to be used and starts any resync etc tha=
t
might be needed.

How is /dev/md1 used?  Is it possible that nothing tried to
write to it until this moment?

If it was something started by a cron job, it would not say
"resync =3D" but rather 'check =3D' or 'repair =3D'.

NeilBrown


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
