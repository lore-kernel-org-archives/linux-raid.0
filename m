From: Michal Suchanek <hramrach@centrum.cz>
Subject: Re: Software RAID and Fakeraid
Date: Tue, 1 Feb 2011 12:04:30 +0100
Message-ID: <AANLkTikt22h=tSKYqotrU+6yj70Uc5592w0JVp0LvCa1@mail.gmail.com>
References: <4CF55680.5010703@cfl.rr.com> <20101201092508.7023f974@notabene.brown>
 <4CF81A16.2010606@cfl.rr.com> <20101203123615.6edce071@notabene.brown>
 <4CF860EB.7010005@cfl.rr.com> <20101209094354.4c6aaa93@notabene.brown>
 <4D01328D.9050503@cfl.rr.com> <4D46E6D7.2000205@cfl.rr.com>
 <20110131170349.GR343@caffeine.csclub.uwaterloo.ca> <4D470BCF.20508@cfl.rr.com>
 <20110131221252.GT343@caffeine.csclub.uwaterloo.ca> <4D47627A.1080509@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D47627A.1080509@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Neil Brown <neilb@suse.de>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1 February 2011 02:31, Phillip Susi <psusi@cfl.rr.com> wrote:
> On 01/31/2011 05:12 PM, Lennart Sorensen wrote:
>>
>> Well one of them stores the raid info at the end of the device, so t=
hat
>> one offers no help for the bootloader at all. =C2=A0I think the othe=
r stores
>
> What do you mean help?
>


I guess that the point of this thread is to determine under what
conditions and where Grub can be installed on a raid array.

Since Grub is somewhat bloated compared to other bootloaders it has
its specific problems. However, the point is that even bootloaders
that do fit into a single sector do need to know where that sector can
be placed, if anywhere, and it is currently not possible to know with
mdraid unless the bootloader reimplements the full mdadm logic itself.

To avoid that mdadm should at the very least provide the information
whether the raid is bios-bootable or not. Ideally it should also
provide a list of sectors unused by the raid format in question.
=46ailing that at least a document clearly summarizing this for various
raid format versions and mdadm reporting the version would be helpful.

Thanks

Michal
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
