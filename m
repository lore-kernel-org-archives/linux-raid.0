From: Luca Berra <bluca@comedia.it>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Tue, 19 Jan 2010 08:21:54 +0100
Message-ID: <20100119072154.GC2891@maude.comedia.it>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <1263242294-5353-3-git-send-email-dledford@redhat.com> <20100119110930.107ca42e@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100119110930.107ca42e@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 19, 2010 at 11:09:30AM +1300, Neil Brown wrote:
>On Mon, 11 Jan 2010 15:38:11 -0500
>Doug Ledford <dledford@redhat.com> wrote:
>
>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>
>I really really don't like this.
>I wasn't very keen on allowing the map file to be found in /dev,
>but this it just too ugly.
>
>I understand there is a problem here, but I don't like this approach to a
>solution.  I'll give it more though when I get home from LCA2010 and see
>what I can come up with.
>
I'll try holding my breath till then :)
well, actually i'll use Doug's patch until a better solution is found.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
