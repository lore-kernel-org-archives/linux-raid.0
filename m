From: Paul Chambers <paul@bod.org>
Subject: Re: Fwd: problems attempting to grow raid5 to raid6 - advice sought
Date: Sat, 25 Nov 2017 16:17:30 -0800
Message-ID: <CALfMqR5CRXVXeDtwysXdH_t28Ns41e8coP+sUQUmksGdqGT2Gw@mail.gmail.com>
References: <CALfMqR47A=5usN-=6v3vUHAPYe-dFQ1Zxhuef0zZzRhXPcQQnQ@mail.gmail.com>
 <CALfMqR5DVqMOwNQwTPwb3y3OH7S-mKy-i=N1_SgvWfbRxbtarw@mail.gmail.com>
 <f182bf54-3942-2cac-bb19-2b31684c5760@youngman.org.uk> <45ae5d62-c9f3-1e3c-6edc-8ece1cc83db8@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ae5d62-c9f3-1e3c-6edc-8ece1cc83db8@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Anthony Youngman <antmbox@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd already tweaked it to invoke Python 2.7 on my system - first thing
I did. The issues I'm seeing are not a trivial python versioning
issue.

For example, it assumes that logical volumes can be found at
/dev/<vg>/<lv>, a path that's not present on this system. I tweaked it
to use /dev/mapper/<vg>-<lv> path instead, which is present in my
system (Proxmox VE, which is debian-based), and then immediately ran
into another issue. Since that was the third non-trivial issue I'd run
into, I decided to cut my losses at that point - recovering this array
is my first priority. I may come back and file bugs later. Maybe even
learn a little bit of python and submit pull requests :)
- Paul
-- 
http://about.me/paul.chambers


On Sat, Nov 25, 2017 at 3:47 PM, Phil Turmel <philip@turmel.org> wrote:
> On 11/25/2017 11:14 AM, Anthony Youngman wrote:
>> On 25/11/17 02:54, Paul Chambers wrote:
>>> Following this script is its output on the system in question. It's
>>> missing the output of lsdrv (sorry), but it has multiple problems
>>> running on my system, and I'm not proficient enough with python to fix
>>> them all.
>>
>> What's your default Python? 3? Then yes it will blow
>> up.
>>
>> I had exactly that problem, and all I did was change the shebang line to
>> explicitly invoke Python 2.7. It worked perfectly.
>
> Yeah, making it compatible with python3 is on my to-do list.
