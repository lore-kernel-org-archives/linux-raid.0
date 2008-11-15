From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: Should we be trying re-write on write errors?
Date: Fri, 14 Nov 2008 19:55:55 -0500
Message-ID: <87f94c370811141655g38558a82ue57938860a4df3d@mail.gmail.com>
References: <200811142130.mAELU6Io009544@wind.enjellic.com>
	 <18717.62614.341600.906790@notabene.brown>
	 <20081115004723.GA24994@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081115004723.GA24994@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Neil Brown <neilb@suse.de>, greg@enjellic.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Sat, Nov 15, 2008 at 08:58:46AM +1100, Neil Brown wrote:
>> On Friday November 14, greg@enjellic.com wrote:
>> > Hi Neil, hope the week is ending well for you and the rest of the
>> > denizens on the linux-raid list.
>> >
>> > Somewhat of a Gedanken question for you.
>> >
>> > We currently attempt a re-write on read error for volumes which ha=
ve
>> > redundancy, ie. RAID[156] etc, on the bet that we can force a bad
>> > sector remap.  Should we be attempting that (or do we) on a write
>> > error as well?
>>
>> I don't think so.
>> By the time md/raid gets an error status, lower levels (Whether driv=
er
>> or firmware) should have retried as much as in appropriate.  Doing
>> further retries at the md level should be pointless.
>>
>> For reads, we do retry.  But the purpose is to find out exactly whic=
h
>> block failed so that we can just re-write that block.  There is no
>> expectation that a block which previously failed a read will now
>> succeed.
>>
>> Similarly there is no reason to expect that a block which previously
>> failed a write will now succeed.
>>
>> I suggest that you might like to discuss your particular case with t=
he
>> author of the driver for the device.  Maybe the driver should be
>> retrying.  Maybe the firmware is doing the wrong thing.
>>
>> After all, you wouldn't expect every different filesystem to retry a=
ll
>> failed writes, would you?
>>
>>
>> >
>> > BTW much thanks for the existing re-write code.  Countless morning=
s
>> > I have said 'gee that Neil Brown was clever' when I see that one o=
f
>> > our machines cleaned up a potential problem before it became a big=
ger
>> > one.
>> :-)
>> To be honest, that code was largely because people kept complaining
>> about read errors being too fatal and wanted something done.  The on=
ly
>> way to stop the flood of complaints was to fix something :-)
>>
>> >
>> > Best wishes for a pleasant weekend.
>>
>> And for you!
>>
>> NeilBrown

<<Moved from the top post to a bottom post>>

On Fri, Nov 14, 2008 at 7:47 PM, Keld J=F8rn Simonsen <keld@dkuug.dk> w=
rote:
> I would like to write something about this fo the wiki.
> What exactly is done, and it is general for all of linux md raid?
>
> best regards
> keld
>

If you are going to document this in a wiki, please document when a
write error can occur because I totally don't understand how this one
occurred.

I thought they could only occur:

1) With bad media on the platter and the reallocatable sectors section
was already 100% utilized

2) Due to a CRC error on the comm path.  (flacky cable / power / etc.)

As I read the below errors, neither of those occurred.  And as Neil
said I believe the retrys related to CRC errors should be handled
below the MD level.

Greg
--=20
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
