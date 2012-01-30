From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 4/4] Spawn mdmon with --offroot if mdadm was launched
 with --offroot
Date: Mon, 30 Jan 2012 10:06:00 +0100
Message-ID: <4F265D78.60006@redhat.com>
References: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>	<1327504684-9219-5-git-send-email-Jes.Sorensen@redhat.com> <20120130121036.09243aa0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120130121036.09243aa0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

On 01/30/12 02:10, NeilBrown wrote:
>> @@ -1622,10 +1624,17 @@ int start_mdmon(int devnum)
>> >  				skipped = 0;
>> >  
>> >  		for (i=0; paths[i]; i++)
>> > -			if (paths[i][0])
>> > -				execl(paths[i], "mdmon",
>> > -				      devnum2devname(devnum),
>> > -				      NULL);
>> > +			if (paths[i][0]) {
>> > +				if (__offroot) {
>> > +					execl(paths[i], "mdmon", "--offroot",
>> > +					      devnum2devname(devnum),
>> > +					      NULL);
> I just occurred to me that this could be:
> 
>     execl(paths[i], "@mdmon", devnum2devname(devnum));
> 
> which seems simpler... but I'll leave it as it is.

Hadn't thought of that :)

> All applied - thanks.

Excellent, will you be able to push it out today? As soon as I see it in
your git repo, I will push it into Fedora rawhide so we can get it tested.

Cheers,
Jes

