From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Tue, 2 May 2017 15:08:36 +0200
Message-ID: <37245817-43d3-7c93-98fe-8b8ce54396ad@powerlamerz.org>
References: <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
 <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de>
 <5c3f7876-1b25-7020-5e7d-01776e7c9903@powerlamerz.org>
 <20170427231242.GA5138@metamorpher.de>
 <4c5d312b-fba6-da20-e08f-ed1a4ba5c313@powerlamerz.org>
 <20170429095656.GA4030@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170429095656.GA4030@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/29/2017 11:56 AM, Andreas Klauer wrote:
> On Sat, Apr 29, 2017 at 12:46:15AM +0200, Patrik Dahlström wrote:
> You could create the RAID first and the overlay afterwards.
> Or you can create loop devices on the busy devices and use those.
I solved it by creating loop devices and use dd. I let it finish, then
ran fsck and resize2fs on the partition and now my data is back!

Thank you all for your invaluable help!

Would it be worth it for me to write up an article on the wiki on how to
re-create messed up metadata?

Best regards
// Patrik
