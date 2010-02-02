From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Mon, 1 Feb 2010 20:08:54 -0800
Message-ID: <4877c76c1002012008u2e32d6a4y9b4fec721dfe8435@mail.gmail.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	 <1263242294-5353-3-git-send-email-dledford@redhat.com>
	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>
	 <4B673A5D.2010901@tmr.com> <4B674860.7080604@redhat.com>
	 <4B6758C7.9060301@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6758C7.9060301@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 1, 2010 at 2:42 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> Doug Ledford wrote:
>>
>> On 02/01/2010 03:32 PM, Bill Davidsen wrote:
>>
>>>
>>> Doug Ledford wrote:
>>>
>>>>
>>>> On 01/18/2010 05:09 PM, Neil Brown wrote:
>>>>
>>>>>
>>>>> I understand there is a problem here, but I don't like this appro=
ach
>>>>> to a
>>>>> solution. =A0I'll give it more though when I get home from LCA201=
0 and
>>>>> see
>>>>> what I can come up with.
>>>>>
>>>>
>>>> Feel free to come up with something different. =A0But, if your sol=
ution
>>>> involves maintaining an additional read/write mount area in defere=
nce to
>>>> a long dead unix tradition, I'm just going to shake my head and pa=
tch
>>>> your solution away to something sane.
>>>>
>>>>
>>>
>>> I don't understand you argument here. Not the one where you say you=
're
>>> going to ignore Neil and do what you want because you can, I unders=
tand
>>> that, but the "additional read/write mount area" part, isn't /var/r=
un
>>> r/w on all systems now? Could you clarify why this is "additional" =
here?
>>>
>>>
>>
>> It's not necessarily read/write in the initrd time frame, and puttin=
g
>> the mdadm files there means it would have to be. =A0We didn't make t=
hese
>> changes because we wanted to, we made them because using mdadm raid
>> arrays for the root filesystem combined with incremental assembly or
>> with imsm raid devices was broken otherwise.
>>
>>
>
> Do understand that my disquiet related to this isn't because you put =
a
> non-device in /dev, it's that you
> didn't put a process PID in /var/run. And frankly, once you let (forc=
e) one
> group of threads to be somewhere
> else, other services will want their PIDs some other place, and anyon=
e
> maintaining an application
> which presents information on what's running will need to know where =
that
> information.
>
> In other words, it's not where you put it, it's where you *didn't* pu=
t it,
> that seems to be an
> invitation to put stuff just anywhere. Neil argues that they are not
> devices, I argue that
> they are PIDs. It's not as though it were a huge effort to move it af=
ter
> pivot root, it's a little code
> or script and in space which will be released.
>
> --
> Bill Davidsen <davidsen@tmr.com>
> =A0"We can't solve today's problems by using the same thinking we
> =A0used in creating them." - Einstein
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Thank you for stating your concern; I think knowing that a very
plausible solution is obvious.

# at initrd/initramfs creation time
ln -s /dev/.run /var/run

#initrd/initramfs script
mkdir /dev/.run

The usual area becomes a symlink to a memory disk .Most systems have
ample memory to support a few extra tiny files there. Cleanup on
reboot is automatic. Any systems that are memory constrained probably
already either have a drive they could swap this data out to, or would
rather save the writes from reaching flash media anyway.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
