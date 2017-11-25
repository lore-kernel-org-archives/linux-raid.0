From: Phil Turmel <philip@turmel.org>
Subject: Re: Fwd: problems attempting to grow raid5 to raid6 - advice sought
Date: Sat, 25 Nov 2017 18:47:43 -0500
Message-ID: <45ae5d62-c9f3-1e3c-6edc-8ece1cc83db8@turmel.org>
References: <CALfMqR47A=5usN-=6v3vUHAPYe-dFQ1Zxhuef0zZzRhXPcQQnQ@mail.gmail.com>
 <CALfMqR5DVqMOwNQwTPwb3y3OH7S-mKy-i=N1_SgvWfbRxbtarw@mail.gmail.com>
 <f182bf54-3942-2cac-bb19-2b31684c5760@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f182bf54-3942-2cac-bb19-2b31684c5760@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antmbox@youngman.org.uk>, Paul Chambers <paul@bod.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/25/2017 11:14 AM, Anthony Youngman wrote:
> On 25/11/17 02:54, Paul Chambers wrote:
>> Following this script is its output on the system in question. It's
>> missing the output of lsdrv (sorry), but it has multiple problems
>> running on my system, and I'm not proficient enough with python to fix
>> them all.
> 
> What's your default Python? 3? Then yes it will blow
> up.
> 
> I had exactly that problem, and all I did was change the shebang line to
> explicitly invoke Python 2.7. It worked perfectly.

Yeah, making it compatible with python3 is on my to-do list.
