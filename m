From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: component device mismatches found: 9600
Date: Tue, 02 Aug 2011 01:35:33 +0100
Message-ID: <4E374655.9040209@anonymous.org.uk>
References: <4E359DC0.5090608@vorgon.com> <CADNH=7H0+RP7yiE01NmxncTBapsMLRt1XkqAHxZr=FEAC9Zx1A@mail.gmail.com> <4E370227.2070804@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E370227.2070804@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/08/2011 20:44, Timothy D. Lenz wrote:
> On 7/31/2011 11:32 AM, Mathias Bur=C3=A9n wrote:
>> On 31 July 2011 19:24, Timothy D. Lenz<tlenz@vorgon.com> wrote:
>>> Looking through the logs, I found this in daemon.log.0. Is this a
>>> sign of a
>>> problem? Below is the entire log:
[...]
>>> Jul 3 01:03:01 x64VDR mdadm[2003]: RebuildFinished event detected o=
n md
>>> device /dev/md1, component device mismatches found: 9600
[...]
> md1 : active raid1 sdb2[1] sda2[0]
> 4891712 blocks [2/2] [UU]

Hmm. Is this 5GB RAID-1 your swap partition? If so, don't worry about i=
t=20
- there is an oddity that mismatches can crop up on RAID-1 arrays when =
a=20
write is abandoned after one drive has been written but the other hasn'=
t=20
(I think that's the explanation), it's most often seen on swap, and it'=
s=20
harmless.

Red Hat disabled reporting mismatches on RAID-1 because of this.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
