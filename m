From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: checking md device parity (forced resync) - is it necessary?
Date: Wed, 06 Sep 2006 10:12:43 +0200
Message-ID: <44FE82FB.3010904@wpkg.org>
References: <44FD3C65.8040000@wpkg.org> <17661.19907.140798.943518@cse.unsw.edu.au> <44FD66C3.6040609@wpkg.org> <edlsqo$jo4$2@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <edlsqo$jo4$2@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> # by default, run at 01:06 on the first Sunday of each month.
>> 6 1 1-7 * 7 root [ -x /usr/share/mdadm/checkarray ] && 
> 
> You have a quite old version of mdadm. This issue has been fixed in
> mdadm (2.5.2-8) unstable from 27 Jul 2006. Current version is mdadm
> (2.5.3.git200608202239-2) unstable from 23 Aug 2006.
> 
> Since the feature did just appear in mdadm (2.5.2-3) UNRELEASED from
> 7 Jul 2006 (and even just went to unstable with mdadm (2.5.2-7) unstable
> from 20 Jul 2006), it seems you were simply in quite bad luck :)

Yes, I saw somewhere in the changelogs that the issue is fixed.

Still, I can't find 2.5.2-8 anywhere on the mirrors, perhaps it's just a 
matter of time...


-- 
Tomasz Chmielewski
http://wpkg.org


