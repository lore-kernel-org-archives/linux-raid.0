From: Luca Berra <bluca@comedia.it>
Subject: Re: [mdadm PATCH 00/13] rebuild / resync checkpointing and other
	external metadata fixes
Date: Wed, 30 Dec 2009 08:19:05 +0100
Message-ID: <20091230071905.GA17485@maude.comedia.it>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com> <20091230135650.05f80646@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091230135650.05f80646@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 30, 2009 at 01:56:50PM +1100, Neil Brown wrote:
>On Tue, 22 Dec 2009 16:59:19 -0700
>Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Hi Neil,
>> 
>> The other bits are a collection of fixes to address unrelated issues
>> discovered along the way.  The result is pushed out to:
>> 
>> 	git://github.com:djbw/mdadm.git master
>> 
>> Please have a look.
>
>Thanks.  Looks good.  Applied.
>
Hi, Dan, Neil
I had the 'pleasure' of testing this patchset (my box keeps kicking disks
out).
I am pleased to note it works perfectly, thanks a lot Dan.

btw, the patches apply both to 3.0.3 and 3.1.1, Neil do you plan on
issuing a 3.0.4 or is now 3.1 considered the stable branch?

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
