From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] barrier support for other md/raid levels
Date: Fri, 18 Sep 2009 14:38:36 -0400
Message-ID: <87f94c370909181138g197be2fegd4032778ca6d3351@mail.gmail.com>
References: <19123.9980.940255.937839@notabene.brown>
	 <4AB372BA.6020101@redhat.com>
	 <4D87015385157D4285D56CA6101072FF26C2CCB1@exchange07.valvesoftware.com>
	 <4AB3D148.3060607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB3D148.3060607@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Green <cgreen@valvesoftware.com>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Tom Coughlan <coughlan@redhat.com>
List-Id: linux-raid.ids

On Fri, Sep 18, 2009 at 2:28 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> On 09/18/2009 02:19 PM, Chris Green wrote:
>>
>> It seems like what you'd need to robustly test barriers is some sort of
>> barrier-supporting loopback device, which
>> acted correctly with barriers, but had worst-case behavior without them
>> (buffering things for random arbitrarily long periods of time,
>> performing all operations in random order, etc).
>>
>>
>>
>
> I think that it is pretty easy to get corruption (defined as fsck issues) if
> we have non-working barriers and do power fail testing. It is a bit tricky
> to automate that though but we are working on it,
>
> ric

Ric,

You are probably already using them to help automate the process, but
if you don't know computer controlled power switches are pretty
standard fare for computer clusters.  I'm sure Redhat's cluster team
has some.

And the cluster team may also have scripts to test things like
unexpected power fails to one of the cluster members.  It may not be
too hard to adjust those scripts to handle your needs.

Greg
