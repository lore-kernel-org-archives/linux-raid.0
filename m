From: maarten <maarten@ultratux.net>
Subject: Re: adding a disk smaller than the array size
Date: Wed, 13 Oct 2004 22:54:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410132254.22483.maarten@ultratux.net>
References: <dff3752704101313303d344fb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dff3752704101313303d344fb8@mail.gmail.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 13 October 2004 22:30, kclair wrote:
> Hello,
>
> I am trying to figure out how I can add a disk that is smaller than
> the size of the raid array to the array.  I'm confused about whether
> simply rebuilding the array with the new disk will work?

Well that is surely a rather incomplete question, since you do not even 
mention which raid level you're talking about.

That said, I don't think this is possible, in most cases. Raid 5 cannot use a 
disk which is smaller than its peers AFAIK, and neither can raid 1.
Obviously too, since they cannot be expected to just 'throw away' part of 
their data...
Whether raid 0 and/or JBOD can I don't know; sure they can be _built_ with all 
sorts of differing drive sizes, but I seem to recall those levels are not 
supported by any on- or offline resizing tool (and they are by definition not 
fault-tolerant so the issue of _replacing_ a drive is thereby moot...).

If you're looking for trouble / complexity you could consider to make a raid 0 
array out of two smaller drives, and add that combo to your existing raid 
set.  Don't know if raid 5 will accept that, but raid 1 will.  But such 
solutions will probably not contribute to stability and reliability... 

Hope that answered your question,
Maarten

> Thanks in advance for any advice,
> Kristina
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

