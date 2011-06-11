From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Triple-parity raid6
Date: Sat, 11 Jun 2011 11:05:08 -0400
Message-ID: <4DF38424.1010500@gmail.com>
References: <isp2g2$rf$1@dough.gmane.org> <20110609114954.243e9e22@notabene.brown> <isqb2o$g0s$1@dough.gmane.org> <20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com> <isslla$o2i$1@dough.gmane.org> <4DF20C18.3030604@christoph-d.de> <ist9n7$khq$1@dough.gmane.org> <20110611101312.GA3528@lazy.lzy> <isvkrg$c79$1@dough.gmane.org> <20110611131801.GA2764@lazy.lzy> <isvvhi$2vf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <isvvhi$2vf$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/2011 10:53 AM, David Brown wrote:

> Yes - we've already established that the implementation will be
> possible, and that there are people willing and able to help with it.
> And I believe that much of the optimisation can be handled by the
> compiler - gcc has come a long way since raid6 was first implemented in
> mdraid.

Hmmm ... don't be too overly reliant upon optimization from a compiler 
for your performance.  It makes sense to have a well designed (and 
proven correct) algorithm first that is hand optimizable.  There are 
many designs which are anathema to performance, and you have to be 
careful to avoid using them in your coding.

We are interested in working on this capability (and more generic 
capability) as well.

Is anyone in particular starting to design/code this?  Please let me know.

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
