From: Luca Berra <bluca@comedia.it>
Subject: Re: [mdadm PATCH 1/2] fix mdmon option parsing
Date: Tue, 2 Mar 2010 08:42:06 +0100
Message-ID: <20100302074206.GB28827@maude.comedia.it>
References: <cover.1267282753.git.bluca@comedia.it> <1-2.1267282753.git.bluca@comedia.it> <20100302164034.48e6da62@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100302164034.48e6da62@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 02, 2010 at 04:40:34PM +1100, Neil Brown wrote:
>On Sat, 27 Feb 2010 16:07:04 +0100
>Luca Berra <bluca@comedia.it> wrote:
>
>> running mdmon --takeover --all resulted in a segfault.
>> also hide "--takeover" from ps and update usage message.
>
>Why do you want to hide the "--takeover" ???
After takeover there is no difference between a normal mdmon and one
that took over, but thinking twice it does not hide very well if we run
"mdmon --takeover --all" versus "mdmon --all --takeover", and maybe
someone is interested in seeing if takeover did work, so you can ignore
this.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
