From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Mon, 13 Jan 2014 18:46:15 -0600
Message-ID: <52D488D7.4080604@hardwarefreak.com>
References: <52BD8EDD.10809@assyoma.it> <20131227151927.GA4003@www5.open-std.org> <52BD9B4F.3000509@assyoma.it> <20131227154952.GA6539@www5.open-std.org> <52CE57D9.1030501@assyoma.it> <20140113102021.1ef3e203@notabene.brown> <52D3A962.4000308@assyoma.it> <20140113204534.737a98f6@notabene.brown> <52D3BCB1.1010200@assyoma.it> <20140114092751.09464b7b@notabene.brown> <20140113233834.GA8885@www5.open-std.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140113233834.GA8885@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com, NeilBrown <neilb@suse.de>
Cc: Gionatan Danti <g.danti@assyoma.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/13/2014 5:38 PM, keld@keldix.com wrote:
> On Tue, Jan 14, 2014 at 09:27:51AM +1100, NeilBrown wrote:
...
>> So this change:
>>
>> http://en.wikipedia.org/w/index.php?title=Non-standard_RAID_levels&diff=501908270&oldid=501604733
>>
>> was wrong.
> 
> Well, it was me doing the wikipedia edit. The edit was done based on information from Neil that this was actually 
> the layout. Then later we found out that it really was not, but it should be; and then Neil implemented
> the better layout.  Maybe it is not called "f2", I look forward to be informed what the actual name 
> will be. 
> 
> I think the name should be "f2" as it is a "far" layout, with 2 copies, and it really should be
> the default for "far" with 2 copies, as the redundancy is much better than the old layout.
> Keeping the name would mean that  we would not need to make and spread documentation on this,
> so that people following existing documentation would automatically get the better implementation.
> There is no need that new raid instances of "far" should get the old layout, except for
> backwards compatibility. 

The problem here is that you're creating the Wikipedia page as if it
*is* source reference material.  I.e. you're including "original work,
your original work.  This is a violation of the Wikipedia rules of
editing.  And this kind of situation is exactly why those rules exist.

The layout tables you are including need to exist in a free to duplicate
reference document, and should be copied verbatim from said document.
They should not be created from scratch simply based on information in
an email exchange on a mailing list, just as web forums are not
considered a valid reference source.

Therefore, if such layout tables do not exist in official Linux
documentation they should not be included in Wikipedia.  If they do
exist, the information should be copied verbatim, and the source
document referenced.  There are no such references in the article.

Wikipedia is an encyclopedia, not a reference work.  All information
needs to be source from reference work.  If you want your original work
to be included in Wikipedia, you need to create your own documentation,
add it to the Linux Documentation Project, and have it peer reviewed.
Then you can include it, and cite that source.

-- 
Stan
