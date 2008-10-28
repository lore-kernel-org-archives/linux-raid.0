From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: dmraid - where is the raid done?
Date: Tue, 28 Oct 2008 13:10:34 +0100
Message-ID: <slrngge09q.ond.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <1225120062.20830.34.camel@pc.ilinx>
 <49064EF0.4080804@gmail.com> <1225154175.16984.16.camel@pc.ilinx>
 <490666F0.4000306@gmail.com> <1225194547.16984.69.camel@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> On Mon, 2008-10-27 at 20:12 -0500, Roger Heflin wrote:
>> If it is dmraid it is being done in the dmraid driver.

There is no such thing like a dmraid driver. dmraid uses the
device-mapper driver (which is why it's called dm*).

> Ahhh.  So in the above "out of kernel driver" instance that is a case
> where dmraid is not handling it, yes?

Well, the "fake"raid in-kernel or "out of kernel" (whatever that means)
drivers have been there far more early. dmraid is a quite new concept
just as device-mapper is.


regards
   Mario
-- 
To err is human. To really foul things up requires a computer.

