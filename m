From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Should we be trying re-write on write errors?
Date: Sun, 16 Nov 2008 23:31:09 -0500
Message-ID: <4920F38D.8040808@gmail.com>
References: <200811142130.mAELU6Io009544@wind.enjellic.com>	 <18717.62614.341600.906790@notabene.brown>	 <20081115004723.GA24994@rap.rap.dk> <87f94c370811141655g38558a82ue57938860a4df3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370811141655g38558a82ue57938860a4df3d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, Neil Brown <neilb@suse.de>, greg@enjellic.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Freemyer wrote:
>> On Sat, Nov 15, 2008 at 08:58:46AM +1100, Neil Brown wrote:
>>    =20
>>> On Friday November 14, greg@enjellic.com wrote:
>>>      =20
>>>> Hi Neil, hope the week is ending well for you and the rest of the
>>>> denizens on the linux-raid list.
>>>>
>>>> Somewhat of a Gedanken question for you.
>>>>
>>>> We currently attempt a re-write on read error for volumes which ha=
ve
>>>> redundancy, ie. RAID[156] etc, on the bet that we can force a bad
>>>> sector remap.  Should we be attempting that (or do we) on a write
>>>> error as well?
>>>>        =20
>>> I don't think so.
>>> By the time md/raid gets an error status, lower levels (Whether dri=
ver
>>> or firmware) should have retried as much as in appropriate.  Doing
>>> further retries at the md level should be pointless.
>>>
>>> For reads, we do retry.  But the purpose is to find out exactly whi=
ch
>>> block failed so that we can just re-write that block.  There is no
>>> expectation that a block which previously failed a read will now
>>> succeed.
>>>
>>> Similarly there is no reason to expect that a block which previousl=
y
>>> failed a write will now succeed.
>>>
>>> I suggest that you might like to discuss your particular case with =
the
>>> author of the driver for the device.  Maybe the driver should be
>>> retrying.  Maybe the firmware is doing the wrong thing.
>>>
>>> After all, you wouldn't expect every different filesystem to retry =
all
>>> failed writes, would you?
>>>
>>>
>>>      =20
>>>> BTW much thanks for the existing re-write code.  Countless morning=
s
>>>> I have said 'gee that Neil Brown was clever' when I see that one o=
f
>>>> our machines cleaned up a potential problem before it became a big=
ger
>>>> one.
>>>>        =20
>>> :-)
>>> To be honest, that code was largely because people kept complaining
>>> about read errors being too fatal and wanted something done.  The o=
nly
>>> way to stop the flood of complaints was to fix something :-)
>>>
>>>      =20
>>>> Best wishes for a pleasant weekend.
>>>>        =20
>>> And for you!
>>>
>>> NeilBrown
>>>      =20
>
> <<Moved from the top post to a bottom post>>
>
> On Fri, Nov 14, 2008 at 7:47 PM, Keld J=F8rn Simonsen <keld@dkuug.dk>=
 wrote:
>  =20
>> I would like to write something about this fo the wiki.
>> What exactly is done, and it is general for all of linux md raid?
>>
>> best regards
>> keld
>>
>>    =20
>
> If you are going to document this in a wiki, please document when a
> write error can occur because I totally don't understand how this one
> occurred.
>
> I thought they could only occur:
>
> 1) With bad media on the platter and the reallocatable sectors sectio=
n
> was already 100% utilized
>
> 2) Due to a CRC error on the comm path.  (flacky cable / power / etc.=
)
>
> As I read the below errors, neither of those occurred.  And as Neil
> said I believe the retrys related to CRC errors should be handled
> below the MD level.
>
> Greg
>  =20

Most of the common write errors you see should not be retried, but you=20
might see some writes fail due to transient conditions.

One possible condition would be vibrations, for example as you wheel a=20
rack around in your data center or you bang into the computer.

 If you are using a SAN, you might also have transient link errors that=
=20
will go away once the switch rights itself or someone plugs back in a=20
new cable...

Ric

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
