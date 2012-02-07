From: Phil Turmel <philip@turmel.org>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Mon, 06 Feb 2012 22:38:27 -0500
Message-ID: <4F309CB3.2080400@turmel.org>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com> <4F30893F.4000709@turmel.org> <CAOANJV955ZdLexRTjVkQzTMapAaMitq5eqxP0rUvDjjLh4Wgzw@mail.gmail.com> <4F309313.2070406@turmel.org> <k4i609x025.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <k4i609x025.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/06/2012 10:24 PM, Keith Keller wrote:
> On 2012-02-07, Phil Turmel <philip@turmel.org> wrote:
>>
>> I understand the constraints, as I pinch pennies at home and at the
>> office (I own my engineering firm).  I've made do with cheap desktop
>> drives that do support ERC.  I got burned when Seagate dropped ERC on
>> their latest desktop drives.  Hitachi Deskstar is the only affordable
>> model on the market that still support ERC.
> 
> I can testify that the EARS/EADS drives can be troublesome (see my
> recent threads on the list).  I also found out that apparently the
> flooding in Thailand is delaying all drive vendors' enterprise drives--
> they seem to be one of the few factories that make an essential part,
> and their factories are all underwater.
> 
> Have others had success with mdraid and the Deskstar drives?  I wouldn't
> mind saving a little money if the drives will actually work, especially
> if I can get them in before April (the earliest one vendor thinks
> they might be able to start building drives again).

Ow.  I haven't actually bought any yet... I was hoping the prices would
come down before I needed to.  Sounds like I'll be waiting longer than
I expected.

But, I reviewed the OEM documentation for the 7K3000 family, and they
clearly document support for the SCT ERC commands (para 9.18.1.2).

Phil
