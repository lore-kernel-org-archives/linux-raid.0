From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: mdadm: hot remove failed for /dev/sdg: Device or resource busy
Date: Tue, 12 Feb 2013 12:31:59 -0800
Message-ID: <velqu9x18l.ln2@goaway.wombat.san-francisco.ca.us>
References: <eqndu9x4h8.ln2@goaway.wombat.san-francisco.ca.us>
 <csvfu9xsdm.ln2@goaway.wombat.san-francisco.ca.us>
 <20130208195935.GA1575@cthulhu.home.robinhill.me.uk>
 <am2gu9xjvm.ln2@goaway.wombat.san-francisco.ca.us>
 <CALwOXvKmgnf8ebHhhyq08M7be_QeAjONzrqB_03UvKXfgafYGQ@mail.gmail.com>
 <u3dgu9x6mo.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Well, I was able to resolve the issue, by stopping the array and
assembling (--force was needed).  The reshape picked up where it left
off, minus one device, and when it completed, the spare was promoted
and a rebuild started.  I'm still confused why the array wouldn't let go
of the device, but at least there's a recourse that is relatively safe.

Thanks for all your help!

--keith

-- 
kkeller@wombat.san-francisco.ca.us


