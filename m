From: Phil Turmel <philip@turmel.org>
Subject: Re: Need help recovering RAID5 array
Date: Tue, 09 Aug 2011 07:38:51 -0400
Message-ID: <4E411C4B.1080200@turmel.org>
References: <4E3C0BCA.9000407@uml.edu> <20110806112910.332d450a@notabene.brown> <D32562736F94C445958A7CC900A95568265503@PORSCHE.fs.uml.edu> <20110809091214.4a830696@notabene.brown> <4E409B76.5030000@uml.edu> <20110809125549.00c56f57@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110809125549.00c56f57@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Stephen Muskiewicz <stephen_muskiewicz@uml.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/08/2011 10:55 PM, NeilBrown wrote:
> On Mon, 8 Aug 2011 22:29:10 -0400 Stephen Muskiewicz <stephen_muskiewicz@uml.edu> wrote:
>> This does lead to a question: Do you recommend (and is it safe on CentOS 
>> 5.5?) for me to use the updated (3.2.2 with your patch) version of mdadm 
>> going forward in place of the CentOS version (2.6.9)?
> 
> I wouldn't kept that patch.  It was a little hack to get your array working
> again.  I wouldn't recommend using it without expert advice...
> 
> Other than that ... 3.2.2 certainly fixes bug and adds features over 2.6.9,
> but maybe it adds some bugs too...  I would say that it is safe, but probably
> not really necessary.
> i.e. up to you :-)

Let me add a reason to stick with 2.6.9:  it has different defaults for
metadata reserved space.  If all hell breaks loose, and you find you need to
do "mdadm --create --assume-clean" or some variant as part of your recovery
efforts, you'll need the older version to get an identical layout.

Phil
