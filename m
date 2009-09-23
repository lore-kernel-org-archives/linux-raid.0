From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: md data-check causes soft lockup
Date: Tue, 22 Sep 2009 21:05:56 -0400
Message-ID: <59D0ECEC8AC946CD9FF2782A9C182060@m5>
References: <4AB7C11E.60801@howardsilvan.com> <70ed7c3e0909211154y3e4abcadyf76822e60127dfad@mail.gmail.com> <4AB8E2A6.2020800@howardsilvan.com> <70ed7c3e0909220748y2e151ebv7f232cf2b7c79617@mail.gmail.com> <4AB8E661.8080706@howardsilvan.com> <20090922151925.GA20382@cthulhu.home.robinhill.me.uk> <4AB926ED.4010900@itb.cnr.it> <70ed7c3e0909221716o3e6d841fj59c6b003374c7a94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909221716o3e6d841fj59c6b003374c7a94@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>, 'Gabriele Trombetti' <gabriele.trombetti@itb.cnr.it>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

But if the applications are locked out, they can't demand anything.  I =
have
seen the same on my Linux server, but only with the 2.6 kernel.  The sa=
me
hardware with a 2.4 kernel was fine.  I have not seen this myself for a=
t
least 1 year, I assumed it was fixed.

When I was locked out my putty session would not respond.  I don't thin=
k it
timed out, but recovered when the rebuild/resync was done.

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Majed B.
} Sent: Tuesday, September 22, 2009 8:17 PM
} To: Gabriele Trombetti
} Cc: linux-raid
} Subject: Re: md data-check causes soft lockup
}=20
} Why would you lower the max value? You should keep the min value as
} low as possible and md would drop to that automatically if there are
} applications demanding access to the array.
}=20
} On Tue, Sep 22, 2009 at 10:35 PM, Gabriele Trombetti
} <gabriele.trombetti@itb.cnr.it> wrote:
} > Robin Hill wrote:
} >>
} >> On Tue Sep 22, 2009 at 07:59:45AM -0700, Lee Howard wrote:
} >>
} >>
} >>>
} >>> Majed B. wrote:
} >>>
} >>>>
} >>>> I must have missed that part. It may not work for your case, but
} worth
} >>>> trying.
} >>>>
} >>>> Perhaps Neil Brown, or someone involved could shed some light on
} this.
} >>>>
} >>>> If I remember correctly, those soft lockups were harmless anyway=
=2E
} >>>>
} >>>
} >>> Not harmless for production use. =A0Yes, data is not harmed, and =
yes,
} the
} >>> problem state does recover when the data-check finishes, but duri=
ng
} the
} >>> data-check the system is virtually unresponsive and all other use=
 of
} the
} >>> system is stalled.
} >>>
} >>>
} >>
} >> Are you sure this is caused by these soft lockups, and that you're=
 not
} >> just running with too high a /sys/block/mdX/md/sync_speed_max sett=
ing?
} >> I've had issues with this on some servers, where the I/O demand fo=
r the
} >> sync/check is causing the system to become totally unresponsive.
} >>
} >
} > That's correct for me in the sense that lowering sync_speed_max sol=
ves
} > the problem, see my post, however I'd call it a bug if a value of
} > sync_speed_max too high starves the system forever. The resync is
} > supposed to be less prioritarian than normal I/O disk operations, b=
ut it
} > doesn't happen this way. Also note that lowering the value of
} > stripe_cache_size also solves the problem: how would this fit into =
your
} > reasoning?
} >
} > (BTW I have not checked the mentioned patch yet, I'm not sure I can=
 do
} > that in a short time because our servers are into production now)
} >
} > --
} > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
} > the body of a message to majordomo@vger.kernel.org
} > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
} >
}=20
}=20
}=20
} --
}        Majed B.
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
