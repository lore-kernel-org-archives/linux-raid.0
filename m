From: David Brown <david.brown@hesbynett.no>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Tue, 30 Apr 2013 08:48:29 +0200
Message-ID: <517F693D.5020700@hesbynett.no>
References: <BA07AEDCFD3B5B4DAB0FF1D7B35E42DC5544BCFA@PRN-MBX01-4.TheFacebook.com> <517EC9D8.8000805@hesbynett.no> <CAA9_cme5Atj2y7aetaRDfiyaBERk-rWCOkw5k7=9YrgcKzYc7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cme5Atj2y7aetaRDfiyaBERk-rWCOkw5k7=9YrgcKzYc7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: Kumar Sundararajan <kumar@fb.com>, NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/04/13 02:05, Dan Williams wrote:
> On Mon, Apr 29, 2013 at 12:28 PM, David Brown <david.brown@hesbynett.no> wrote:
>> For each data block you are changing, you will need to remove the old g^i *
>> Di_old then add in the new g^i * Di_new, so you can still use this
>> simplification to reduce the number of multiplies.  If you want to change
>> blocks "i" and "j", you thus do:
>>
>> Q_new = Q_old + g^i * (Di_old + Di_new) + g^j * (Dj_old + Dj_new)
>>
>> But as I say, I only know the maths - not the code.
> 
> The issue is where to store those intermediate Di_old + Di_new results
> without doubling the size of the stripe cache.
> 

(As before, I haven't looked at the code.  I justify my laziness by
claiming that I might come up with fresh ideas without how to implement
things.  But only you folks can say what takes more work, and what is
riskier in the code.)

I don't see that you would need to double the size of the stripe cache.
 You might need an extra few block spaces, but not double the cache.

Also, once you have done this calculation (assuming you did the easy
P_new first), you no longer need to keep Di_old lying around - it's
going to be replaced with the new stripe data.  So maybe you can do the
operation as "Di_old += Di_new" - i.e., in place and without using more
memory.  That is going to be faster too, as it is more cache friendly.
On the other hand, it might involve more locking or other tracking
mechanisms to avoid problems if something else is trying to access the
same caches.

