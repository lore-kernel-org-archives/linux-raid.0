From: berk walker <berk@panix.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 25 Mar 2005 15:54:29 -0500
Message-ID: <42447A85.2070409@panix.com>
References: <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com> <20050322093525.GL7040@percy.comedia.it> <8275h2-sn4.ln1@news.it.uc3m.es> <20050323203125.GD26683@percy.comedia.it> <i63eh2-eat.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <i63eh2-eat.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

as I understand it, the topic is what happens when a RAID0 which is 
split twixt remote sites loses communication.  What would you suggest as 
a method to keep the obvious from happening?

A proactive approach, perhaps?  Since, it seems, that write requests do 
not have to be ack'd immediatly, there *will* be a total sync loss.  Are 
the write logs deep enough to be able to be used to resync, once the 
systems realize that they are no longer connected?  From what I've read, 
the bitmaps will be no help in reconstruction, but just in error 
detection (correct me if needed).
This is indeed an interesting topic, and one that strikes close to home.
b-
