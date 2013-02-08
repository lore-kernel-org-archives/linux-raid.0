From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: mdadm: hot remove failed for /dev/sdg: Device or resource busy
Date: Fri, 08 Feb 2013 15:08:14 -0800
Message-ID: <u3dgu9x6mo.ln2@goaway.wombat.san-francisco.ca.us>
References: <eqndu9x4h8.ln2@goaway.wombat.san-francisco.ca.us>
 <csvfu9xsdm.ln2@goaway.wombat.san-francisco.ca.us>
 <20130208195935.GA1575@cthulhu.home.robinhill.me.uk>
 <am2gu9xjvm.ln2@goaway.wombat.san-francisco.ca.us>
 <CALwOXvKmgnf8ebHhhyq08M7be_QeAjONzrqB_03UvKXfgafYGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-02-08, John Gehring <john.gehring@gmail.com> wrote:
> Not sure, but you may want to read the thread:
>
> 6. 2012-01-03  Re: [PATCH] FIX: Cannot remove failed disk from conta
> linux-rai NeilBrown
>
>
> http://marc.info/?l=linux-raid&m=132555140730996&w=2

I'm not totally sure I understand, but are you implying that pulling the
most recent version from git might help?  If so, unfortunately it did
not help.  I'd already tried 3.2.6, and I just tried Neil's git repo,
and neither was successful in removing the failed device:

# ~/mdadm/mdadm --version
mdadm - v3.2.5 - 18th May 2012
# ~/mdadm/mdadm /dev/md127 --remove /dev/sdg
mdadm: hot remove failed for /dev/sdg: Device or resource busy
# ~/mdadm-3.2.6/mdadm --version
mdadm - v3.2.6 - 25th October 2012
# ~/mdadm-3.2.6/mdadm /dev/md127 --remove /dev/sdg
mdadm: hot remove failed for /dev/sdg: Device or resource busy

I can see how the initial report might be similar to the current
situation, but it seems like the patch wasn't able to remove the device.
(I did check to make sure that my local downloaded versions of mdadm did
indeed have the patch; both do.)

--keith

-- 
kkeller-usenet@wombat.san-francisco.ca.us
(try just my userid to email me)
AOLSFAQ=http://www.therockgarden.ca/aolsfaq.txt
see X- headers for PGP signature information


